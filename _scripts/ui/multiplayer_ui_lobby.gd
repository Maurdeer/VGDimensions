extends VBoxContainer

@onready var card_manager: CardManager = $"../CardManager"
@export var card_res: Card
var DEFAULT_IP_ADDRESS: String = "localhost"
var DEFAULT_PORT: int = 12345

func _ready() -> void:
	if multiplayer.is_server():
		multiplayer.peer_connected.connect(_on_peer_joined)

func _on_host_pressed() -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(DEFAULT_PORT)
	multiplayer.multiplayer_peer = peer
	CardShop.Instance.fill_up_shop()
	_hide_lobby_menu()

func _on_join_pressed() -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(DEFAULT_IP_ADDRESS, DEFAULT_PORT)
	multiplayer.multiplayer_peer = peer
	_hide_lobby_menu()
	
func _on_peer_joined(id: int) -> void:
	CardShop.Instance.rpc_id(id, "refresh_shop", CardShop.Instance.m_card_ids)

func _on_spawn_card_pressed() -> void:
	CardShop.Instance.remove_all_cards()
	CardShop.Instance.fill_up_shop()
	
func _hide_lobby_menu() -> void:
	$Host.visible = false
	$Join.visible = false
	$SpawnCard.visible = true
	$Label.visible = true
	$Label.text = "%s" % multiplayer.get_unique_id()
# Replace with function body.
