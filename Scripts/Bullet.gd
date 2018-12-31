extends KinematicBody2D

export (Vector2) var velocity
export (int) var projectile_range
var projectile_lifetime
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

# Initialization method for correct orientation
# Need to do this to give server authority over projectile direction
func init(direction):
	# var direction = get_parent().get_node("Movement").get_direction();
	velocity.y = velocity.y*direction["y"]
	velocity.x = velocity.x*direction["x"]	

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	var speed = velocity.length()
	if speed == 0: # Division by zero edge case
		projectile_lifetime = 0
	else:
		projectile_lifetime = projectile_range/speed

func _physics_process(delta):
	var collision_object = move_and_collide(velocity)
	projectile_lifetime -= delta
	if projectile_lifetime <= 0.0:
        queue_free()
	if collision_object:
		print('collision occured!')
		queue_free()

