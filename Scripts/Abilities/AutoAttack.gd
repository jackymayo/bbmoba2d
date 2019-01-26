extends "res://Scripts/Ability.gd"

var cooldownTime = 1.0
var cooldownTimer = 0.0

#func get_player(player_id):
#	return get_node("/root/Server/Game/Map/Players/%s" % str(player_id))# $'/root/Server/Game/Map/Players'.get_node(str(player_id))

static func validate(player):
	""" Returns whether or not the ability cast was valid. """
	print("check if he has 100iq")
	return true

# Returns an actor
static func construct_actor(player):
	""" Returns an actor to be constructed by a child of the scene tree. """
	
	# Instantiate actor
	var bullet_scene = preload('res://Scenes/Bullet.tscn')
	var bullet_node = bullet_scene.instance()

	# Grab some stuff
	var player_pos = player.get_position()
#	var player_pos = player.transform[2] # [x-axis, y-axis, origin]
	var direction = player.get_direction()
	var spawn_offset = 20
	var deg = 90
	
	player_pos.x += direction.x*spawn_offset
	player_pos.y += direction.y*spawn_offset

#	match direction:
#		Constants.LEFT:
#			deg = 180
#			player_pos.x -= spawn_offset
#		Constants.RIGHT:
#			deg = 0
##			player_pos.x += spawn_offset
#		Constants.DOWN:
#			deg = 90
##			player_pos.y += spawn_offset
#		Constants.UP:
#			deg = 270
##			player_pos.y -= spawn_offset
#		_:
#			pass
	
	bullet_node.init(player.get_direction())
	
	# Update network's bullet count (for testing)
	Network.scene_data.bullet_count += 1 	
	# Give bullet a unique sequential name
	bullet_node.set_name(str(Network.scene_data.bullet_count))
	
	# Positioning
	bullet_node.get_node("Sprite").rotate(deg2rad(deg))
	bullet_node.set_position(player_pos) 
	
	# Turns out not adding it to map cause some weird warping in projectile shooting when
	# moving the script
	# :thonk:
	
	return bullet_node

static func spawn_particles(player):
	pass