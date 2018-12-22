extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var bulletCount = 0 # This would need to pass to something else
var bulletScene

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	bulletScene = load('res://Scenes/Bullet.tscn')

func _collisionEvent(object):
	""" TODO:
	
	Args:
		Object this object has collided with.
		
	"""
	pass

	
func projectile_shoot():
	""" Shoots a projectile from the player node
	"""
	var playerPos = get_parent().get_node('Movement').get_position()

	var bulletNode = bulletScene.instance()
	
	bulletCount += 1
	bulletNode.set_name(str(bulletCount))
	
	# TODO: Get player orientation and rotate sprite accordingly
	# TODO: Also add padding to avoid player postiion from being bumped by collider
	var direction = get_parent().get_node('Movement').get_direction()
	"""
	Magic Numbers to change the direction of the bullet
	"""
	var deg = 90
	
	if direction.x == -1:
		deg = 180
		playerPos.x -= 20
	elif direction.x == 1:
		deg = 0
		playerPos.x += 20
	elif direction.y == 1:
		deg = 90
		playerPos.y += 20
	else:
		deg = 270
		playerPos.y -= 20
	var playerOrientation = deg2rad(deg)
	
	""" The collision is calculated strangely.
	Given that the bullet is 16x16, and the player is 64x64
	You would assume that the offset would be 8 + 32
	However it's 20 """
	# ¯\_(ツ)_/¯ 

	#playerPos.y += 20
	bulletNode.set_position(playerPos) # TODO: Direction should be accounted for in offset
	
	bulletNode.get_node("Sprite").rotate(playerOrientation)

	# HEHEHE REVIEWED
	# get_node('/root/Server/Game/Map/').add_child(bulletNode)
	add_child(bulletNode)



	
func get_input():
	""" This would be merged into one get_input later on
	"""
	if Input.is_action_just_pressed('auto_attack'):
		print("Auto attack")
		# Should be kinematic collision
		projectile_shoot()

func _physics_process(delta):
	get_input()
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
