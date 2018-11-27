extends Node

const DEFAULT_IP = '127.0.0.1'
const DEFAULT_PORT = 30003
const MAX_PLAYERS = 5

func _ready():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(DEFAULT_PORT, MAX_PLAYERS)
	get_tree().set_network_peer(peer)