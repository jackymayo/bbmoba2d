extends Node

remote func pre_configure_game():
    var selfPeerID = get_tree().get_network_unique_id()

    var map = load("res://Scenes/Map.tscn").instance()
    get_node("/root/Server/Game").add_child(map)

    # Load player
    var player = preload("res://Scenes/Player.tscn").instance()
    player.set_name(str(selfPeerID))
    # player.set_network_master(selfPeerID) #
    get_node("/root/Server/Game/Map/Players").add_child(player)

    # Tell server (remember, server is always ID=1) that this peer is done pre-configuring
    rpc_id(1, "done_preconfiguring", selfPeerID)

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pre_configure_game()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
