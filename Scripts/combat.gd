extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var bullet_scene

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	bullet_scene = preload('res://Scenes/Bullet.tscn')

func request_shoot():
	""" Sends request for shot to server.
	"""
	
	if get_tree().is_network_server():
		_projectile_shoot(1)
	else:
		# Request projectile shoot for player ID
		rpc_id(1, '_projectile_shoot', get_tree().get_network_unique_id())


remote func _projectile_shoot(projectile_source_id):
	""" Shoots a projectile from the player node
	"""
	
	# offset to avoid spawning on player
	var spawn_offset = 20
	
	# Compute source position based on server-side ground truth
	var source_player = $'/root/Server/Game/Map/Players'.get_node(str(projectile_source_id))
	var player_pos = source_player.get_position()
	# TODO: Get player orientation and rotate sprite accordingly
	# TODO: Also add padding to avoid player postiion from being bumped by collider
	var direction = source_player.get_direction()

	# Magic Numbers to change the direction of the bullet
	# :))))))))
	var deg = 90
	if direction.x == -1:
		deg = 180
		player_pos.x -= spawn_offset
	elif direction.x == 1:
		deg = 0
		player_pos.x += spawn_offset
	elif direction.y == 1:
		deg = 90
		player_pos.y += spawn_offset
	else:
		deg = 270
		player_pos.y -= spawn_offset
	
	# Grab player orientation
	var player_orientation = direction	
	
	# Broadcast bullet spawn
	# TODO: use rpc(...) instead
	for id in Network.players.keys():
		if id == 1:
			_spawn_projectile(player_orientation, player_pos)
		else:
			rpc_id(id, '_spawn_projectile', player_orientation, player_pos)

# Spawns projectile based on sever-side reckoning of source position
remote func _spawn_projectile(source_orientation, source_position):
	# Instance a bullet
	var bullet_node = bullet_scene.instance()
	bullet_node.init(source_orientation)
	
	Network.scene_data.bullet_count += 1
	bullet_node.set_name(str(Network.scene_data.bullet_count))
	
	""" The collision is calculated strangely.
	Given that the bullet is 16x16, and the player is 64x64
	You would assume that the offset would be 8 + 32
	However it's 20 """
	# ¯\_(ツ)_/¯
	bullet_node.set_position(source_position) # TODO: Direction should be accounted for in offset
	bullet_node.get_node("Sprite").rotate(atan2(source_orientation['x'], source_orientation['y']))
	
	# Turns out not adding it to map cause some weird warping in projectile shooting when
	# moving the script
	get_node('/root/Server/Game/Map/Projectiles/').add_child(bullet_node)
	#add_child(bulletNode)


func get_input():
	""" This would be merged into one get_input later on
	"""
	
	# Important: command input needs to be wrapped so only the appropriate
	# Player node listens
	if get_parent().name == str(get_tree().get_network_unique_id()):
		if Input.is_action_just_pressed('auto_attack'):
			print("Auto attack requested!")
			# Should be kinematic collision
			request_shoot()

func _physics_process(delta):
	# TEMP: Get attack key input
	get_input()
	
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
