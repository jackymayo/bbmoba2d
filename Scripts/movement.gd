extends KinematicBody2D

# class member variables go here, for example:
# var a = 2


func _ready():
	""" Called when the node is added to the scene for the first time.
	"""
	pass


func get_input():
	"""Create a velocity vector to pass into Godot physics functions.
	e.g. move_and_slide( Vector2() ), move_and_collide( Vector2() )
		
	Returns: 
		A Vector2 object
	"""

	var velocity = Vector2()
	if Input.is_action_pressed('ui_left'):
		velocity.x -= 1
	if Input.is_action_pressed('ui_right'):
		velocity.x += 1
	if Input.is_action_pressed('ui_up'):
		velocity.y -= 1
	if Input.is_action_pressed('ui_down'):
		velocity.y += 1	
	
	# Normalize vector components so diagonal is not sonic speederinos.
	velocity = velocity.normalized() * movementSpeed
	
	return velocity

func _physics_process(delta):
	var vector = get_input()
	move_and_slide(vector)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
