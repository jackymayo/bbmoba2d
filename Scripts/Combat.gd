extends "res://Scripts/Ability.gd"

# TODO: Lock time, lock bool from abilities (to signal how long the player
# cannot cast, and whether or not the player can move while the ability
# is locking)

""" Combat mechanics
@details Usage: Static scripts extending Ability are dragged into
  the editor to provide abilityBasic, abilityCharge, abilityMine, and abilityUlt.
  
  The structure of this script is to abstract out the networking and "piping" to
  make ability development easier.
"""

# Drag-and-drop abilities
export (GDScript) var abilityBasic
export (GDScript) var abilityCharge
export (GDScript) var abilityMine
export (GDScript) var abilityUlt

# Array of timers for ability cooldown
var ability_timers

func _init():
	# Initialize ability cooldown timers
	ability_timers = [Timer.new(),
	                  Timer.new(),
	                  Timer.new(),
	                  Timer.new()]
	for timer in ability_timers:
		# Set timer to not restart
		timer.one_shot = true
		# Add to scene tree
		add_child(timer)


func _request(ability_index, cooldown_timer):
	""" Request ability to fire, delegating resource check to Ability script run by
	  the correct client.
	
	@param[in] ability_index (int) Index in [0,3] corresponding to ability slot
	@param[in,out] cooldown_timer (Timer) Timer object for corresponding ability slot
	
	@details If is network server, initiates use of ability (check resources) locally; else
	  rpc's the network host to do so.	
	"""
	
	if get_tree().is_network_server():
		# Proceed to resource validation
		_validate_request(ability_index, 1, cooldown_timer)
	else:
		# Request projectile shoot for player ID
		rpc_id(1, "_validate_request", ability_index, get_tree().get_network_unique_id(), cooldown_timer)

remote func _validate_request(ability_index, player_id, cooldown_timer):
	""" Checks if ability is ready to be fired, and then executes
	(server-side).
	
	@param[in] ability_index (int) Index in [0,3] corresponding to ability slot
	@param[in] player_id (int) Network id of player
	@param[in,out] cooldown_timer (Timer) Timer object for corresponding ability slot
	@pre Function must be called on server
	
	@details Selects the correct ability's methods to call.
	"""
	
	# Get player object
	var player = $'/root/Server/Game/Map/Players'.get_node(str(player_id))
	
	# Check if resources are available to cast the ability
	# HACK: Godot seems to lack both metaprogramming (eval) and
	# the ability to pass static function references--only instances
	# and their methods (using funcref) can be passed; see
	# https://docs.godotengine.org/en/3.1/classes/class_funcref.html
	# The way we write abilities right now is *non-instanced*.
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
	""" Sets up construction of the ability actors (e.g. projectiles), instant or delayed
	
	@param[in] ability_index (int) Index in [0,3] corresponding to ability slot
	@param[in] player_id (int) Network id of player
	@param[in,out] cooldown_timer (Timer) Timer object for corresponding ability slot

	@post Actor construction is lined up using *client-side values*
	@details Called on any client.
	"""
	
#	# TEST: Print this client's network id
#	print(get_tree().get_network_unique_id())
	
	# Get player object
	var player = $'/root/Server/Game/Map/Players'.get_node(str(player_id))
	# Get execution instructions for specified ability
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
	
	# Execute all instructions, which contain a delay field
	for exec in execs:
		if exec.delay > 0:
			# Add actor construction timer
			# TODO: check garbage collection
			var timer = Timer.new()
			timer.one_shot = true
			# Connect actor construction function to fire when timer ends
			timer.connect("timeout", self,
			  "_evoke_construct_actor", [ability_index, player_id])
			timer.set_wait_time(exec.delay)
			timer.start()
			# Crucial: add timer as child in scene tree
			add_child(timer)
		else:
			# Immediately finish actor construction
			_evoke_construct_actor(ability_index, player_id)

func _evoke_construct_actor(ability_index, player_id):
	""" Constructs the actor by delegating to the ability's construct_actor method.
	
	@param[in] ability_index (int) Index in [0,3] corresponding to ability slot
	@param[in] player_id (int) Network id of player

	@post Actor is constructed, and it knows what to do when it collides with
	  something (i.e., apply any on-hit effects to the something).

	@details Called on any client. 
	"""
	
	# Get player node
	var player = $'/root/Server/Game/Map/Players'.get_node(str(player_id))
	# Call actor constructor corresponding to ability slot
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

	# Save source name to projectile scene in case needed later
	new_projectile_scene.source_name = player.name
	# Prevent collision with source player
	new_projectile_scene.add_collision_exception_with(player)
	# TODO: prevent collision with walls and environment

	# Choose the corresponding on-hit callback function
	var on_hit_callback_name = ""
	# NOTE: This bad boy's why we need this verbose and weird structure.
	# We can't otherwise get the correct method name into the callback since
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

	# Connect on-hit callback function to the hit signal fired by projectile collision
	new_projectile_scene.connect("hit", self, on_hit_callback_name)

	# Add projectile scene to scene tree
	get_node('/root/Server/Game/Map/Projectiles/').add_child(new_projectile_scene)

func ability_basic_on_hit(target):
	""" On-hit function wrapper.
	param[in,out] target (KinematicCollision2D) : Collision object
	
	@details Wraps the function to this script so that signals
	  can find this function by name. Calls the delegated on-hit
	  function using only the collider portion of collision object
	  (i.e., the "player" or mob object).
	"""

#	print("Ability 1 hit! Target:" + str(target.collider.vitals))
	print("Ability 1 hit!")
	abilityBasic.on_hit_effect(target.collider)	

func ability_charge_on_hit(target):
	""" On-hit function wrapper.
	param[in,out] target (KinematicCollision2D) : Collision object
	
	@details Wraps the function to this script so that signals
	  can find this function by name. Calls the delegated on-hit
	  function using only the collider portion of collision object
	  (i.e., the "player" or mob object).
	"""

	print("Ability 2 hit!")
	abilityCharge.on_hit_effect(target.collider)

func ability_mine_on_hit(target):
	""" On-hit function wrapper.
	param[in,out] target (KinematicCollision2D) : Collision object
	
	@details Wraps the function to this script so that signals
	  can find this function by name. Calls the delegated on-hit
	  function using only the collider portion of collision object
	  (i.e., the "player" or mob object).
	"""

	print("Ability 3 hit!")
	abilityMine.on_hit_effect(target.collider)

func ability_ult_on_hit(target):
	""" On-hit function wrapper.
	param[in,out] target (KinematicCollision2D) : Collision object
	
	@details Wraps the function to this script so that signals
	  can find this function by name. Calls the delegated on-hit
	  function using only the collider portion of collision object
	  (i.e., the "player" or mob object).
	"""

	print("Ability 4 hit!")
	abilityUlt.on_hit_effect(target.collider)

func get_input():
	""" Handle inputs.
		
	@details Wraps the function to this script so that signals
	  can find this function by name. Calls the delegated on-hit
	  function using only the collider portion of collision object
	  (i.e., the "player" or mob object).
	
	  TODO: This would be merged into one get_input later on
	"""
	
	# Important: command input needs to be wrapped so only the Player
	# node corresponding to this client responds; here get_parent()
	# should be the Player node, and its network id should be that of
	# the client that controls that Player.
	if get_parent().name == str(get_tree().get_network_unique_id()):
		if Input.is_action_just_pressed('auto_attack'):
#			print("Auto attack requested!")
			_request(0, ability_timers[0])
		if Input.is_action_just_pressed('charge_attack'):
#			print("Attack 2 requested!")
			_request(1, ability_timers[1])
		if Input.is_action_just_pressed('lay_mine'):
#			print("Mine requested!")
			_request(2, ability_timers[2])
		if Input.is_action_just_pressed('use_ult'):
#			print("Ultimate requested!")
			_request(3, ability_timers[3])

func _physics_process(delta):
	""" Godot standard physics process callback.
	"""
	# TEMP: Get attack key input
	get_input()
	
