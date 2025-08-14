extends VBoxContainer

@onready var card_manager: CardManager = $"../CardManager"
@export var card_res: Card
var DEFAULT_IP_ADDRESS: String = "localhost"
var DEFAULT_PORT: int = 12345

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

func _on_spawn_card_pressed() -> void:
	if !card_res: 
		printerr("Can't spawn with null card")
		return
	card_manager.rpc("spawn_new_card", {"card_res" : card_res})
	
func _hide_lobby_menu() -> void:
	$Host.visible = false
	$Join.visible = false
	$SpawnCard.visible = true
	$Label.visible = true
	$Label.text = "%s" % multiplayer.get_unique_id()
# Replace with function body.
