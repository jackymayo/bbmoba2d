extends "res://Scripts/Ability.gd"

const cooldown = 1.2
const mp_cost = 0.4

"""
Experimental skill that shoots three times

@details Implements: cooldowns, resource costs, delayed actor construction
"""

static func validate(player, cooldown_timer):
	""" Returns whether or not the ability cast was valid.
	
	@param[in,out] player Reference to player node
	@param[in] cooldown-timer (Timer) Reference to Timer object corresponding
	  to this ability slot
	@return (bool) Whether or not this ability can be used
	"""
	
	# If have enough resources and cooled down
	if player.vitals.mp >= mp_cost and cooldown_timer.is_stopped():
		# Pay costs
		player.vitals.mp -= mp_cost
		return true
	else:
		print("Can't cast!")
		return false

static func execute(player, cooldown_timer):
	""" Executes the action, returning timings for missile to fire.
	
	@param[in,out] player Reference to player node
	@param[in,out] cooldown_timer (Timer) Reference to Timer object corresponding
	  to this ability slot
	@return (Array of objs with "delay" field) Fire timings for projectiles
	
	@future Can be extended to return, in addition to the time delay, other
	  triggers or specific function strings (for functions defined here, e.g.
	  to do some special stuff).
	@details Returns some delays and stuff, after which by default
	  construct_actor is called.
	"""
	
	# Pay cooldowns
	cooldown_timer.set_wait_time(cooldown)
	cooldown_timer.start()
	return [{"delay": 0.0},
	        {"delay": 0.2},
			{"delay": 0.45}]

static func construct_actor(player):
	""" Returns an actor to be constructed by a child node of the scene tree.
	
	@param[in] player Reference to player node
	@return (Scene instance) Instance of the actor (projectile) at the correct pos
	
	"""

	# Instantiate actor
	var bullet_scene = preload('res://Scenes/Bullet.tscn')
	var bullet_node = bullet_scene.instance()

	# Compute position
	var position = player.get_position()
	var direction = player.get_direction()
	var spawn_offset = 20
	var deg = 90

	position.x += direction.x*spawn_offset
	position.y += direction.y*spawn_offset

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
	bullet_node.set_position(position)

	# Turns out not adding it to map cause some weird warping in projectile shooting when
	# moving the script
	# :thonk:

	return bullet_node

static func spawn_particles(player):
	pass