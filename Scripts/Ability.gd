extends Node

""" Virtual ability template
Extend this script to use this interface. Does not need
to be instanced. Defines methods of a GDScript object.

@related On GDScript type: https://docs.godotengine.org/en/3.0/classes/class_gdscript.html
"""

func _init():
	print("Virtual: Don't init me bro")

static func validate(player, cooldown_timer):
	""" Returns whether or not the ability cast was valid.

	@param[in,out] player Reference to player node
	@param[in] cooldown-timer (Timer) Reference to Timer object corresponding
	  to this ability slot
	@return (bool) Whether or not this ability can be used
	"""

	print("Virtual: Can't fire a non-existent ability")
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

	print("Virtual: Can't execute a non-existent ability")
	return null

static func construct_actor(player):
	""" Returns an actor to be constructed by a child node of the scene tree.

	@param[in] player Reference to player node
	@return (Scene instance) Instance of the actor (projectile) at the correct pos
	
	"""

	print("Virtual: Can't construct nothing")
	return null

static func on_hit_effect(target):
	print("Virtual: No effect!")
	return null

static func spawn_particles(player):
	""" Returns collection of particles to be constructed by child of scene tree.
	
	@param[in] player Reference to player node
	@return (Array of Scene instance) Sprites to render"""
	return null