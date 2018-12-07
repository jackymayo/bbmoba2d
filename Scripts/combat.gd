extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var bulletCount = 0
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _collisionEvent(object):
	""" TODO:
	
	Args:
		Object this object has collided with.
		
	"""

	
func projectile_shoot():
	""" Shoots a projectile from the player node
	"""
	var playerPos = get_parent().get_node('Movement').get_position()
	var bulletNode = load('res://Scripts/Bullet.gd').new()
	
	bulletCount += 1
	bulletNode.set_name(str(bulletCount))
	bulletNode.set_position(playerPos)

	var arrow = Sprite.new()
	arrow.set_name('%s arrow'  % bulletCount)
	arrow.set_texture(preload('res://Assets/projectiles/arrow.png'))
	
	# TODO: Get player orientation and rotate sprite accordingly
	var playerOrientation = deg2rad(90)
	arrow.rotate(playerOrientation)
	bulletNode.add_child(arrow)	
	get_node('/root/Server/Game/Map/').add_child(bulletNode)
	



	
func get_input():
	""" This would be merged into one get_input later on
	"""
	if Input.is_action_just_pressed('auto_attack'):
		print("Auto attack")
		# Should be kinematic collision
		projectile_shoot()

		pass

func _physics_process(delta):
	get_input()
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
