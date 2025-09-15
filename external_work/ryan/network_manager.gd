extends Node
class_name NetworkManager

const DEFAULT_IP_ADDRESS: String = "localhost"
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
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
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
	
func _on_player_connected(peer_id):
	pass

func _on_player_disconnected(peer_id):
	pass

func undp_setup() -> void:
	var upnp = UPNP.new()
	
	var discover_result = upnp.discover()
	assert(discover_result == UPNP.UPNP_RESULT_SUCCESS, \
		"UPNP Discover Failed! Error %s" % discover_result)
		
	assert(upnp.get_gateway() and upnp.get_gateway().is_valid_gateway(), \
		"UPNP Invalid Gateway!")
		
	var map_result = upnp.add_port_mapping(DEFAULT_PORT, 0, "", "TCP", 0)
	assert(map_result == UPNP.UPNP_RESULT_SUCCESS, \
		"UPNP Port Mapping Failed! Error %s" % map_result)
		
	print("Success! Join Address: %s" % upnp.query_external_address())
	
	upnp.delete_port_mapping(DEFAULT_PORT, "TCP")
	
