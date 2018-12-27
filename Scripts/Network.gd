extends Node

const DEFAULT_IP = '127.0.0.1'
const DEFAULT_PORT = 31400
const MAX_PLAYERS = 4

var players = { }
var self_data = { name = '', position = Vector2(360, 180) }

signal player_disconnected
signal server_disconnected

	
func _ready():
	get_tree().connect('network_peer_disconnected', self, '_on_player_disconnected')
	get_tree().connect('network_peer_connected', self, '_on_player_connected')

func create_server(player_name):
	self_data.name = player_name
	players[1] = self_data
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(DEFAULT_PORT, MAX_PLAYERS)
	get_tree().set_network_peer(peer)

func connect_to_server(player_name):
	self_data.name = player_name
	# Should be adding a listener for event 'connected_to_server'
	get_tree().connect('connected_to_server', self, '_connected_to_server')
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(DEFAULT_IP, DEFAULT_PORT)
	get_tree().set_network_peer(peer)

func _connected_to_server():
	var local_player_id = get_tree().get_network_unique_id()
	players[local_player_id] = self_data
	rpc('_send_player_info', local_player_id, self_data)

func _on_player_disconnected(id):
	players.erase(id)

func _on_player_connected(connected_player_id):
	var local_player_id = get_tree().get_network_unique_id()
	# Debug
	print(str(connected_player_id) + " " + str(local_player_id))
	# If not server, initiate chain through server to resolve (eventually) _send_player_info
	if not(get_tree().is_network_server()):
		rpc_id(1, '_request_player_info', local_player_id, connected_player_id)

remote func _request_player_info(request_from_id, player_id):
	if get_tree().is_network_server():
		rpc_id(request_from_id, '_send_player_info', player_id, players[player_id])

# A function to be used if needed. The purpose is to request all players in the current session.
remote func _request_players(request_from_id):
	if get_tree().is_network_server():
		for peer_id in players:
			if( peer_id != request_from_id):
				rpc_id(request_from_id, '_send_player_info', peer_id, players[peer_id])

# Executed by server via an rpc to server in _connected_to_server() and
# executed by clients using information delivered by server
# via the rpc chain initiated by clients
remote func _send_player_info(id, info):
	players[id] = info
	var new_player = load('res://Scenes/Player.tscn').instance()
	new_player.name = str(id)
	# Client at [id] is set as master of new player
	new_player.set_network_master(id)
	# Add player instance as child to server's tree under Players
	$'/root/Server/Game/Map/Players'.add_child(new_player)
	new_player.init(info.name, info.position, true)

func update_position(id, position):
	players[id].position = position
