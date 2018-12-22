extends KinematicBody2D

export (Vector2) var velocity

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	
	pass

func _physics_process(delta):
	var collision_object = move_and_collide(velocity)
	if collision_object:
		print('collision occured!')
		queue_free()
