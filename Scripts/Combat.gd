extends "res://Scripts/Ability.gd"

# Drag-and-drop abilities
export (GDScript) var abilityBasic
export (GDScript) var abilityCharge
export (GDScript) var abilityMine
export (GDScript) var abilityUlt

var ability_timers

func _init():
	# Not using, and probably don't need :))))
	# Ability timers
	ability_timers = [Timer.new(),
	                  Timer.new(),
	                  Timer.new(),
	                  Timer.new()]
	for timer in ability_timers:
		timer.one_shot = true
		add_child(timer)
	
#	ability1 = load("res://Scripts/Abilities/AutoAttack.gd") #abilityBasic.new()
#	ability2 = abilityCharge.instance()
#	ability3 = abilityMine.instance()
#	ability4 = abilityUlt.instance()
#	ability1 = load("res://Scripts/Abilities/AutoAttack.gd")

func _request(ability, cooldown_timer):
	""" Send request to server to fire _ability_
	"""
	
	if get_tree().is_network_server():
		_validate_request(ability, 1, cooldown_timer)
	else:
		# Request projectile shoot for player ID
		rpc_id(1, "_validate_request", ability, get_tree().get_network_unique_id(), cooldown_timer)

remote func _validate_request(ability, player_id, cooldown_timer):
	""" Checks if ability is ready to be fired, and then executes
	(server-side).
	
	@pre: function is called on server
	
	Note: can't do this within the Ability script, which is
	not a scene (and is thus not instantiated).
	"""
	
	# Get player object
	var player = $'/root/Server/Game/Map/Players'.get_node(str(player_id))
	
	# Validate using ability's validation function
	if ability.validate(player, cooldown_timer):
		# Ability valid; ask all clients to construct
		rpc('_process_request', ability, player_id, cooldown_timer)
	else:
		# Can't fire; TODO: add insufficient resources messages
		pass

sync func _process_request(ability, player_id, cooldown_timer):
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
	var execs = ability.execute(player, cooldown_timer)
	
	for exec in execs:
		if exec.delay > 0:
			# Add actor construction timer
			var timer = Timer.new()
			timer.one_shot = true
			timer.connect("timeout", self,
			  "_evoke_construct_actor", [ability, player_id])
			timer.set_wait_time(exec.delay)
			timer.start()
			# Crucial: add timer as child in scene tree
			add_child(timer)
		else:
			# Add constructed projectile as child to projectiles branch of scene tree
			_evoke_construct_actor(ability, player_id)
	
#	# Add any delayed-effect callbacks
#	var callbacks = ability.post_callbacks(player)
#	for item in callbacks:
#		item.delay
#		var timer = Timer.new()
func _evoke_construct_actor(ability, player_id):
	var player = $'/root/Server/Game/Map/Players'.get_node(str(player_id))
	get_node('/root/Server/Game/Map/Projectiles/').add_child(ability.construct_actor(player))
		

func get_input():
	""" TODO: This would be merged into one get_input later on
	"""
	
	# Important: command input needs to be wrapped so only the appropriate
	# Player node listens
	if get_parent().name == str(get_tree().get_network_unique_id()):
		if Input.is_action_just_pressed('auto_attack'):
			print("Auto attack requested!")
			# Should be kinematic collision
			_request(abilityBasic, ability_timers[0])
		if Input.is_action_just_pressed('charge_attack'):
			print("Attack 2 requested!")
			_request(abilityCharge, ability_timers[1])
		if Input.is_action_just_pressed('lay_mine'):
			print("Mine requested!")
			_request(abilityMine, ability_timers[2])
		if Input.is_action_just_pressed('use_ult'):
			print("Ultimate requested!")
			_request(abilityUlt, ability_timers[3])

func _physics_process(delta):
	# TEMP: Get attack key input
	get_input()
	
