extends "res://Scripts/Ability.gd"

# TODO: Lock time, lock bool from abilities (to signal how long the player
# cannot cast, and whether or not the player can move while the ability
# is locking)

# Drag-and-drop abilities
export (GDScript) var abilityBasic
export (GDScript) var abilityCharge
export (GDScript) var abilityMine
export (GDScript) var abilityUlt

var ability_timers

func _init():
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

func _request(ability_index, cooldown_timer):
	""" Send request to server to fire _ability_
	"""
	
	if get_tree().is_network_server():
		_validate_request(ability_index, 1, cooldown_timer)
	else:
		# Request projectile shoot for player ID
		rpc_id(1, "_validate_request", ability_index, get_tree().get_network_unique_id(), cooldown_timer)

remote func _validate_request(ability_index, player_id, cooldown_timer):
	""" Checks if ability is ready to be fired, and then executes
	(server-side).
	
	@pre: function is called on server
	
	Note: can't do this within the Ability script, which is
	not a scene (and is thus not instantiated).
	"""
	
	# Get player object
	var player = $'/root/Server/Game/Map/Players'.get_node(str(player_id))
	
	# Validation
	# HACK: Godot seems to lack both metaprogramming (eval) and
	# the ability to pass static function references--only instances
	# and the way we write abilities is non-instanced.
	var is_valid = false
	match ability_index:
		0:
			is_valid = abilityBasic.validate(player, cooldown_timer)
		1:
			is_valid = abilityCharge.validate(player, cooldown_timer)
		2:
			is_valid = abilityMine.validate(player, cooldown_timer)
		3:
			is_valid = abilityUlt.validate(player, cooldown_timer)
		_:
			print("Unexpected error: impossible ability index")
	
	# Validate using ability's validation function
	if is_valid:
		# Ability valid; ask all clients to construct
		rpc('_process_request', ability_index, player_id, cooldown_timer)
	else:
		# Can't fire; TODO: add insufficient resources messages
		pass

sync func _process_request(ability_index, player_id, cooldown_timer):
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
	var execs
	match ability_index:
		0:
			execs = abilityBasic.execute(player, cooldown_timer)
		1:
			execs = abilityCharge.execute(player, cooldown_timer)
		2:
			execs = abilityMine.execute(player, cooldown_timer)
		3:
			execs = abilityUlt.execute(player, cooldown_timer)
		_:
			print("Unexpected error: impossible ability index")
#	var execs = abilities_array[ability_index].execute(player, cooldown_timer)
	
	for exec in execs:
		if exec.delay > 0:
			# Add actor construction timer
			var timer = Timer.new()
			timer.one_shot = true
			timer.connect("timeout", self,
			  "_evoke_construct_actor", [ability_index, player_id])
			timer.set_wait_time(exec.delay)
			timer.start()
			# Crucial: add timer as child in scene tree
			add_child(timer)
		else:
			# Add constructed projectile as child to projectiles branch of scene tree
			_evoke_construct_actor(ability_index, player_id)
	
#	# Add any delayed-effect callbacks
#	var callbacks = ability.post_callbacks(player)
#	for item in callbacks:
#		item.delay
#		var timer = Timer.new()
func _evoke_construct_actor(ability_index, player_id):
	# Get player node
	var player = $'/root/Server/Game/Map/Players'.get_node(str(player_id))
	# Call actor constructor
	var new_projectile_scene
	match ability_index:
		0:
			new_projectile_scene = abilityBasic.construct_actor(player)
		1:
			new_projectile_scene = abilityCharge.construct_actor(player)
		2:
			new_projectile_scene = abilityMine.construct_actor(player)
		3:
			new_projectile_scene = abilityUlt.construct_actor(player)
		_:
			print("Unexpected error: impossible ability index")
	# Save source name
	new_projectile_scene.source_name = player.name
	# Prevent collision with source player
	new_projectile_scene.add_collision_exception_with(player)
	# Connect signaling
#	print(ability.name)
#	var x = funcref(self, "ability.on_hit_effect")
	var on_hit_callback_name = ""
	# NOTE: This bad boy's why we need this verbose and weird structure.
	# Can't otherwise get the write method name into the callback since
	# Godot doesn't treat functions as first-class objects.
	match ability_index:
		0:
			on_hit_callback_name = "ability_basic_on_hit"
		1:
			on_hit_callback_name = "ability_charge_on_hit"
		2:
			on_hit_callback_name = "ability_mine_on_hit"
		3:
			on_hit_callback_name = "ability_ult_on_hit"
		_:
			print("Unexpected error: impossible ability index")
	new_projectile_scene.connect("hit", self, on_hit_callback_name)
	# Add projectile scene to scene tree
	get_node('/root/Server/Game/Map/Projectiles/').add_child(new_projectile_scene)

# Wrapper to localize the functions, giving the signals a place to find
# these functions by name. Also extracts the collider for the delegated
# function.
func ability_basic_on_hit(target):
	"""
	param[in] target (KinematicCollision2D) : Collision object
	"""
	print("Ability 1 hit! Target:" + str(target.collider.vitals))
	abilityBasic.on_hit_effect(target.collider)	

func ability_charge_on_hit(target):
	print("Ability 2 hit!")
	abilityCharge.on_hit_effect(target.collider)

func ability_mine_on_hit(target):
	print("Ability 3 hit!")
	abilityMine.on_hit_effect(target.collider)

func ability_ult_on_hit(target):
	print("Ability 4 hit!")
	abilityUlt.on_hit_effect(target.collider)

func get_input():
	""" TODO: This would be merged into one get_input later on
	"""
	
	# Important: command input needs to be wrapped so only the appropriate
	# Player node listens
	if get_parent().name == str(get_tree().get_network_unique_id()):
		if Input.is_action_just_pressed('auto_attack'):
			print("Auto attack requested!")
			_request(0, ability_timers[0])
		if Input.is_action_just_pressed('charge_attack'):
			print("Attack 2 requested!")
			_request(1, ability_timers[1])
		if Input.is_action_just_pressed('lay_mine'):
			print("Mine requested!")
			_request(2, ability_timers[2])
		if Input.is_action_just_pressed('use_ult'):
			print("Ultimate requested!")
			_request(3, ability_timers[3])

func _physics_process(delta):
	# TEMP: Get attack key input
	get_input()
	
