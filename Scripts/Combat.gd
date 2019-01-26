extends "res://Scripts/Ability.gd"

# Drag-and-drop abilities
export (GDScript) var abilityBasic
export (GDScript) var abilityCharge
export (GDScript) var abilityMine
export (GDScript) var abilityUlt

func _init():
	# Not using, and probably don't need :))))
#	ability1 = abilityBasic.instance()
#	ability1 = load("res://Scripts/Abilities/AutoAttack.gd")
	pass

func request(ability):
	""" Send request to server to fire _ability_
	"""
	
	if get_tree().is_network_server():
		_validate_request(ability, 1)
	else:
		# Request projectile shoot for player ID
		rpc_id(1, "_validate_request", ability, get_tree().get_network_unique_id())

remote func _validate_request(ability, player_id):
	""" Checks if ability is ready to be fired, and then executes
	(server-side).
	
	@pre: function is called on server
	
	Note: can't do this within the Ability script, which is
	not a scene (and is thus not instantiated).
	"""
	
	# Get player object
	var player = $'/root/Server/Game/Map/Players'.get_node(str(player_id))
	
	# Validate using ability's validation function
	if ability.validate(player):
		# Ability valid; ask all clients to construct
		rpc('_process_request', ability, player_id)
	else:
		# Can't fire; TODO: add insufficient resources messages
		pass

sync func _process_request(ability, player_id):
	print(get_tree().get_network_unique_id())
	""" Executes the ability, with source player_id
	
	@pre: ability is valid
	@post: ability is fired using client-side values
	
	Note: can't do this within the Ability script, which is
	not a scene (and is thus not instantiated).
	"""
	
	# Get player object
	var player = $'/root/Server/Game/Map/Players'.get_node(str(player_id))
	# Construct actor using specified ability's routine
	var bullet_node = ability.construct_actor(player)
	# Add constructed projectile as child to projectiles branch of scene tree
	get_node('/root/Server/Game/Map/Projectiles/').add_child(bullet_node)

func get_input():
	""" TODO: This would be merged into one get_input later on
	"""
	
	# Important: command input needs to be wrapped so only the appropriate
	# Player node listens
	if get_parent().name == str(get_tree().get_network_unique_id()):
		if Input.is_action_just_pressed('auto_attack'):
			print("Auto attack requested!")
			# Should be kinematic collision
			request(abilityBasic)
		if Input.is_action_just_pressed('charge_attack'):
			print("Attack 2 requested!")
			request(abilityCharge)
		if Input.is_action_just_pressed('lay_mine'):
			print("Mine requested!")
			request(abilityMine)
		if Input.is_action_just_pressed('use_ult'):
			print("Ultimate requested!")
			request(abilityUlt)

func _physics_process(delta):
	# TEMP: Get attack key input
	get_input()
	
