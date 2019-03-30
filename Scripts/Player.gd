extends KinematicBody2D

export (int) var movementSpeed 

# HP and stuff
var initial_maxhp = 50.0
var initial_maxmp = 20.0
var vitals = {"maxhp": initial_maxhp,
			  "maxmp": initial_maxmp,
			  "hp": initial_maxhp,
			  "mp" : initial_maxmp}

var direction = {"x" : 0, "y" : 1}

slave var slave_position = Vector2()
slave var slave_velocity = Vector2()
slave var slave_direction = direction # Set default direction

func _ready():
	# Set up Health globe
	$HUD/HealthGUI.max_value = vitals.maxhp
	$HUD/HealthGUI.value = vitals.hp
	$HUD/ManaGUI.max_value = vitals.maxmp
	$HUD/ManaGUI.value = vitals.mp
	# Check if this client controls this player
	if name == str(get_tree().get_network_unique_id()):
		pass
	else:
		# Client does not control this player
		remove_child($HUD)
		pass

func get_direction():
	return direction;

func get_input():
	"""Create a velocity vector to pass into Godot physics functions.
	e.g. move_and_slide( Vector2() ), move_and_collide( Vector2() )
		
	Returns: 
		A Vector2 object
	"""

	var velocity = Vector2()
	if Input.is_action_pressed('ui_left'):
		velocity.x -= 1
		direction["x"] = -1
		direction["y"] = 0
	if Input.is_action_pressed('ui_right'):
		velocity.x += 1
		direction["x"] = 1
		direction["y"] = 0
	if Input.is_action_pressed('ui_up'):
		velocity.y -= 1
		direction["x"] = 0
		direction["y"] = -1
	if Input.is_action_pressed('ui_down'):
		velocity.y += 1
		direction["x"] = 0
		direction["y"] = 1
	
	# Normalize vector components so diagonal is not sonic speederinos.
	velocity = velocity.normalized() * movementSpeed
	
	return [velocity, direction]

func _process(delta):
	# Check if this client controls this player
	if name == str(get_tree().get_network_unique_id()):
		$HUD/HealthText.text = "HP: " + str(vitals.hp) + "/" + str(vitals.maxhp)
		$HUD/HealthGUI.value = vitals.hp
		$HUD/ManaText.text = "MP: " + str(vitals.mp) + "/" + str(vitals.maxmp)
		$HUD/ManaGUI.value = vitals.mp

func _physics_process(delta):

	if is_network_master():
		# Capture key presses and get velocity using helper function
		var output = get_input()
		var velocity = output[0]
		direction = output[1]
		
		# Send updates to slaves
		rset_unreliable('slave_position', position)
		rset_unreliable('slave_velocity', velocity)
		rset_unreliable('slave_direction', direction)
		# rset('slave_movement', direction)

		#move_and_slide(vector)
		move_and_collide(velocity)
	else: # Following
		#move_and_slide(vector)
		move_and_collide(slave_velocity)
		position = slave_position
		direction = slave_direction
	
	if get_tree().is_network_server():
		Network.update_position(1, position)

func init(nickname, start_position, is_slave):
	global_position = start_position
	if is_slave:
		$Sprite.texture = load('res://Assets/beebois/freddy/freddy-alt.png')
		
	""" i dunno what this is for but keeping it for reference o_o
	This is for making the camera follow, but it's in the wrong place :))))
    else:
		$Camera.make_current()
		print("FOLLOW" + nickname)"""


""" Pasta
func damage(value):
	health_points -= value
	if health_points <= 0:
		health_points = 0
		rpc('_die')
	_update_health_bar()

sync func _die():
	$RespawnTimer.start()
	set_physics_process(false)
	$Rifle.set_process(false)
	for child in get_children():
		if child.has_method('hide'):
			child.hide()
	$CollisionShape2D.disabled = true


func _on_RespawnTimer_timeout():
	set_physics_process(true)
	$Rifle.set_process(true)
	for child in get_children():
		if child.has_method('show'):
			child.show()
	$CollisionShape2D.disabled = false
	health_points = MAX_HP
	_update_health_bar()
"""
