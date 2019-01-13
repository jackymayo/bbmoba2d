extends "../Ability.gd"

func get_player(player_id):
	return $'/root/Server/Game/Map/Players'.get_node(str(player_id))

remote func validate(player_id):
	# Check some player property
	print("check if he has 100iq")

remote func construct_actor(player_id):
	var bullet_scene = preload('res://Scenes/Bullet.tscn')
	var bullet_node = bullet_scene.instance()

	var player = get_player(player_id)
	var player_pos = player.get_position()
	var direction = player.get_direction()
	var spawn_offset = 20
	var deg = 90
	
	# Switch statement example
	match direction:
		Constants.LEFT:
			deg = 180
			player_pos.x -= spawn_offset
		Constants.RIGHT:
			deg = 0
			player_pos.x += spawn_offset
		Constants.DOWN:
			deg = 90
			player_pos.y += spawn_offset
		Constants.UP:
			deg = 270
			player_pos.y -= spawn_offset
		_:
			pass
	
	bullet_node.init(player.get_unit_vector())
	
	Network.scene_data.bullet_count += 1 
	bullet_node.set_name(str(Network.scene_data.bullet_count))
	
	bullet_node.set_position(player_pos) 
	bullet_node.get_node("Sprite").rotate(deg2rad(deg))
	
	# Turns out not adding it to map cause some weird warping in projectile shooting when
	# moving the script
	get_node('/root/Server/Game/Map/Projectiles/').add_child(bullet_node)
	return bullet_scene

remote func spawn_particles(player_id):
	pass