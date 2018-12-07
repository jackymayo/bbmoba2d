extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var bulletCount = 0 # This would need to pass to something else

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

	var bulletNode = load('res://Scenes/Bullet.tscn').instance()
	
	bulletCount += 1
	bulletNode.set_name(str(bulletCount))

	
	# TODO: Get player orientation and rotate sprite accordingly
	# TODO: Also add padding to avoid player postiion from being bumped by collider
	var playerOrientation = deg2rad(90)
	
	""" The collision is calculated strangely.
	Given that the bullet is 16x16, and the player is 64x64
	You would assume that the offset would be 8 + 32
	However it's 20 """
	# ¯\_(ツ)_/¯ 

	playerPos.y += 20 
	bulletNode.set_position(playerPos) # TODO: Direction should be accounted for in offset
	
	bulletNode.get_child(0).rotate(playerOrientation)

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
