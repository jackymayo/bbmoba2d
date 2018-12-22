extends Node

remote func pre_configure_game():
	get_tree().connect('network_peer_disconnected', self, '_on_player_disconnected')
	get_tree().connect('server_disconnected', self, '_on_server_disconnected')
	# Load the map
	var map = load("res://Scenes/Map.tscn").instance()
	get_node("/root/Server/Game").add_child(map)
	
	# Host creates server 

	var selfPeerId = get_tree().get_network_unique_id()
	var new_player = preload("res://Scenes/Player.tscn").instance()
	new_player.name = str(selfPeerId)
	new_player.set_network_master(selfPeerId)
	$'/root/Server/Game/Map/Players'.add_child(new_player)
	
	# Tell server (remember, server is always ID=1) that this peer is done pre-configuring
	#if not get_tree().is_network_server():
	#	rpc_id(1, "done_preconfiguring", selfPeerId)

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here)
	pre_configure_game()

func _on_player_disconnected(id):
	get_node(str(id)).queue_free()

