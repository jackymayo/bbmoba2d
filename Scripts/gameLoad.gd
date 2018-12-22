extends Node

remote func pre_configure_game():

	
	var map = load("res://Scenes/Map.tscn").instance()
	get_node("/root/Server/Game").add_child(map)
	var Network = get_parent()
	
	Network.create_server("joe")
	var selfPeerID = get_tree().get_network_unique_id()
	# If you're the server add your player in
	if get_tree().is_network_server():
		var new_player = load("res://Scenes/Player.tscn").instance()
		$'/root/Server/Game/Map/Players'.add_child(new_player)
	# Tell server (remember, server is always ID=1) that this peer is done pre-configuring
	else:
		rpc_id(1, "done_preconfiguring", selfPeerID)
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here)
	pre_configure_game()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
