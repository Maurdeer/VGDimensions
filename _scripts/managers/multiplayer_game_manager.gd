extends GameManager
class_name MultiplayerGameManager
@onready var chat: Chat = $Chat
@onready var name_label: Label = $PlayerHandUI/name_label

func _ready() -> void:
	if multiplayer.is_server():
		GNM.all_players_loaded.connect(_start_game)
	super._ready()
	
func _after_ready() -> void:
	name_label.text = GNM.player_info['name']
	GNM.player_loaded.rpc()

# Should be only invoked my the Server
func _start_game() -> void:
	if not multiplayer.is_server(): return
	chat.create_message.rpc("Game Will Start!")
	setup_card_shop()
	setup_rift_grid()
	create_cards_for_player_hand()
	
func create_cards_for_player_hand():
	_create_cards_for_player_hand_rpc.rpc()
	
@rpc("any_peer", "call_local", "reliable")
func _create_cards_for_player_hand_rpc():
	var player_hand_cards: Array[Card] = CardManager.create_cards(cards)
	for card in player_hand_cards:
		player_hand.discard_card(card)
		
	player_hand.fill_hand()
