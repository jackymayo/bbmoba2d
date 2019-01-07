extends Node2D

func request():
	""" Sends request for shot to server.
	"""

	if get_tree().is_network_server():
		Abilities.get_node('fredUlt').construct_actor(1)
	else:
		# Request projectile shoot for player ID
		# rpc_id(1, 'Abilities.fredUlt.validate', get_tree().get_network_unique_id())
		# above doesn't work so i comment ;)
		pass
	

func get_input():
	""" This would be merged into one get_input later on
	"""
	
	# Important: command input needs to be wrapped so only the appropriate
	# Player node listens
	if get_parent().name == str(get_tree().get_network_unique_id()):
		if Input.is_action_just_pressed('auto_attack'):
			print("Auto attack requested!")
			# Should be kinematic collision
			request()

func _physics_process(delta):
	# TEMP: Get attack key input
	get_input()
	
