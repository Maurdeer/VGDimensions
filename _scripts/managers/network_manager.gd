extends Node

signal player_connected(pid)
signal player_disconnected(pid)
signal server_disconnected
signal all_players_loaded

var DEFAULT_IP_ADDRESS: String = "localhost"
const DEFAULT_PORT: int = 12345
var peer: ENetMultiplayerPeer

var players = {}

# Local Player info
var player_info = {'name' : "Name"}
var players_loaded = 0

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
	player_connected.emit(1)
	
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
	
func disconnect_self():
	_disconnect_peer.rpc(multiplayer.get_unique_id())
	remove_multiplayer_peer()
	get_tree().change_scene_to_file("res://_scenes/networking/network_lobby.tscn")
	
@rpc("call_local", "reliable")
func _disconnect_peer(pid: int):
	if multiplayer.is_server():
		multiplayer.multiplayer_peer.disconnect_peer(pid, true)
	
func _on_player_connected(id):
	_register_player.rpc_id(id, player_info)
	
# When the server decides to start the game from a UI scene,
# do Lobby.load_game.rpc(filepath)
@rpc("call_local", "reliable")
func load_game(game_scene_path):
	get_tree().change_scene_to_file(game_scene_path)
	
# Every peer will call this when they have loaded the game scene.
@rpc("any_peer", "call_local", "reliable")
func player_loaded():
	if multiplayer.is_server():
		players_loaded += 1
		if players_loaded == players.size():
			all_players_loaded.emit()
			players_loaded = 0


@rpc("any_peer", "reliable")
func _register_player(new_player_info):
	var new_player_id = multiplayer.get_remote_sender_id()
	players[new_player_id] = new_player_info
	player_connected.emit(new_player_id)
	
func _on_player_disconnected(id):
	player_disconnected.emit(id)
	players.erase(id)
	disconnect_self()
	

func _on_connected_ok():
	var peer_id = multiplayer.get_unique_id()
	players[peer_id] = player_info
	player_connected.emit(peer_id)


func _on_connected_fail():
	remove_multiplayer_peer()

func _on_server_disconnected():
	remove_multiplayer_peer()
	players.clear()
	server_disconnected.emit()
	
# Barrier Implemenation for networking
var players_processed_passive: int = 0
signal process
@rpc("any_peer", "call_local", "reliable")
func _increment_count() -> void:
	players_processed_passive += 1
	
func barrier() -> void:
	if not multiplayer.multiplayer_peer: return
	_increment_count.rpc()
	# (Ryan) Keep an eye on this if there are any problems in the future
	if players_processed_passive == GNM.players.size():
		process.emit()
	else:
		await process
	players_processed_passive = 0
	
