extends KinematicBody2D

export (Vector2) var velocity
export (int) var projectile_range
var projectile_lifetime
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	var direction = get_parent().get_parent().get_node("Movement").get_direction();
	velocity.y = velocity.y*direction["y"]
	velocity.x = velocity.x*direction["x"]
	projectile_lifetime = projectile_range/(sqrt(pow(velocity.x,2) + pow(velocity.y,2)))
	pass

func _physics_process(delta):
	var collision_object = move_and_collide(velocity)
	projectile_lifetime -= delta
	if projectile_lifetime <= 0.0:
        queue_free()
	if collision_object:
		print('collision occured!')
		queue_free()

