extends Node
class_name NetworkManager

signal player_connected(pid, player_info)
signal player_disconnected(pid)
signal server_disconnected

var DEFAULT_IP_ADDRESS: String = "localhost"
const DEFAULT_PORT: int = 12345
var peer: ENetMultiplayerPeer

var players = {}

# Local Player info
var player_info = {'name' : "Name"}

func _ready():
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	
func host(p_player_name: String, port: int = DEFAULT_PORT) -> bool:
	# Setup ENetMultiplayerPeer
	peer = ENetMultiplayerPeer.new()
	var err = peer.create_server(port, 2)
	if err != OK:
		printerr("Could not Host")
		return false
	multiplayer.multiplayer_peer = peer
	
	# Setup player_info
	player_info['name'] = p_player_name
	
	# Attach player to players
	players[1] = player_info
	player_connected.emit(1, player_info)
	
	return true
	
func client(p_player_name: String, ip_addr: String = DEFAULT_IP_ADDRESS, port: int = DEFAULT_PORT) -> bool:
	# Setup ENetMultiplayerPeer
	peer = ENetMultiplayerPeer.new()
	var err = peer.create_client(ip_addr, port)
	if err != OK:
		remove_multiplayer_peer()
		return false
	multiplayer.multiplayer_peer = peer
	
	# Setup player_info
	player_info['name'] = p_player_name
	return true
	
func remove_multiplayer_peer():
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
	players.clear()
	
func _on_player_connected(id):
	_register_player.rpc_id(id, player_info)


@rpc("any_peer", "reliable")
func _register_player(new_player_info):
	var new_player_id = multiplayer.get_remote_sender_id()
	players[new_player_id] = new_player_info
	player_connected.emit(new_player_id, new_player_info)
	
func _on_player_disconnected(id):
	players.erase(id)
	player_disconnected.emit(id)

func _on_connected_ok():
	var peer_id = multiplayer.get_unique_id()
	players[peer_id] = player_info
	player_connected.emit(peer_id, player_info)


func _on_connected_fail():
	remove_multiplayer_peer()

func _on_server_disconnected():
	remove_multiplayer_peer()
	players.clear()
	server_disconnected.emit()
	
