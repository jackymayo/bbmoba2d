extends KinematicBody2D

export (int) var movementSpeed 
enum MoveDirection {DOWN, LEFT, UP, RIGHT}

slave var slave_position = Vector2()
slave var slave_velocity = Vector2()
slave var slave_direction = MoveDirection.DOWN

func _ready():
	pass

func get_input():
	"""Create a velocity vector to pass into Godot physics functions.
	e.g. move_and_slide( Vector2() ), move_and_collide( Vector2() )
		
	Returns: 
		A Vector2 object
	"""
	var velocity = Vector2()
	var direction = DOWN
	if Input.is_action_pressed('ui_left'):
		# TODO
		direction = LEFT
		velocity.x -= 1
	if Input.is_action_pressed('ui_right'):
		direction = RIGHT
		velocity.x += 1
	if Input.is_action_pressed('ui_up'):
		direction = UP
		velocity.y -= 1
	if Input.is_action_pressed('ui_down'):
		direction = DOWN
		velocity.y += 1	
	
	# Normalize vector components so diagonal is not sonic speederinos.
	velocity = velocity.normalized() * movementSpeed
	
	return [velocity, direction]

func _physics_process(delta):
	var direction = MoveDirection.DOWN
	if is_network_master():
		# Capture key presses and get velocity using helper function
		var output = get_input()
		var velocity = output[0]
		direction = output[1]
		
		# Send updates to slaves
		rset_unreliable('slave_position', position)
		rset_unreliable('slave_velocity', velocity)
		rset('slave_movement', direction)

		#move_and_slide(vector)
		move_and_collide(velocity)
	else: # Following
		#move_and_slide(vector)
		move_and_collide(slave_velocity)
		position = slave_position
	
	if get_tree().is_network_server():
		Network.update_position(1, position)


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


func init(nickname, start_position, is_slave):
	$GUI/Nickname.text = nickname
	global_position = start_position
	if is_slave:
		$Sprite.texture = load('res://player/player-alt.png')
"""
