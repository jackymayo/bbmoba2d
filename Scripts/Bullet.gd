extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var velocity 
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	velocity = Vector2()
	velocity.y += 4

func _physics_process(delta):
	var collision_object = move_and_collide(velocity)
	if collision_object:
		print('collision occured!')
		queue_free()
	pass
