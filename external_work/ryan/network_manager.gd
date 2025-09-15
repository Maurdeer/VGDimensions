extends Node
class_name NetworkManager

var DEFAULT_IP_ADDRESS: String = "localhost"
const DEFAULT_PORT: int = 12345
var peer: ENetMultiplayerPeer
var player_name: String

func host(p_player_name: String, port: int = DEFAULT_PORT) -> bool:
	peer = ENetMultiplayerPeer.new()
	var err = peer.create_server(port, 2)
	if err != OK:
		printerr("Could not Host")
		return false
		
	multiplayer.multiplayer_peer = peer
	#multiplayer.peer_connected.connect(_on_player_connected)
	#multiplayer.peer_disconnected.connect(_on_player_disconnected)
	player_name = p_player_name
	get_tree().change_scene_to_file("res://external_work/ryan/chat.tscn")
	return true
	
func client(p_player_name: String, ip_addr: String = DEFAULT_IP_ADDRESS, port: int = DEFAULT_PORT) -> bool:
	peer = ENetMultiplayerPeer.new()
	var err = peer.create_client(ip_addr, port)
	if err != OK:
		return false
	multiplayer.multiplayer_peer = peer
	player_name = p_player_name
	get_tree().change_scene_to_file("res://external_work/ryan/chat.tscn")
	return true
	
#func _on_player_connected(peer_id):
	#pass
#
#func _on_player_disconnected(peer_id):
	#pass
	
