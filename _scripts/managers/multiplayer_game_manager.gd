extends GameManager
class_name MultiplayerGameManager
@onready var chat: Chat = $Chat
@onready var name_label: Label = $PlayerHandUI/name_label

var player_turn_queue: Array[int]
var curr_turn: int

func _ready() -> void:
	if multiplayer.is_server():
		GNM.all_players_loaded.connect(_start_game)
	super._ready()
	
func _after_ready() -> void:
	name_label.text = GNM.player_info['name']
	initial_player_stats()
	GNM.player_loaded.rpc()

# Should be only invoked my the Server
func _start_game() -> void:
	if not multiplayer.is_server(): return
	chat.create_message.rpc("Game Will Start!")
	setup_card_shop()
	setup_rift_grid()
	create_cards_for_player_hand()
	curr_turn = 0
	player_turn_queue.append(multiplayer.get_unique_id())
	for pid in multiplayer.get_peers():
		player_turn_queue.push_back(pid)
	_set_up_each_peer.rpc()
	_setup_player_turn.rpc(player_turn_queue[curr_turn])

func start_next_turn() -> void:
	# End Current Player Turn
	end_local_play_turn()
	on_end_of_turn.emit()
	
	_start_next_turn.rpc()
	
@rpc("any_peer", "call_remote", "reliable")
func _set_up_each_peer(p_curr_turn: int, p_player_turn_queue: Array[int]) -> void:
	curr_turn = p_curr_turn
	player_turn_queue = p_player_turn_queue
	
@rpc("any_peer", "call_local", "reliable")
func _start_next_turn() -> void:
	curr_turn = (curr_turn + 1) % player_turn_queue.size()
	if not multiplayer.is_server(): return
	_setup_player_turn.rpc(player_turn_queue[curr_turn])
	
func create_cards_for_player_hand():
	_create_cards_for_player_hand_rpc.rpc()
	
@rpc("any_peer", "call_local", "reliable")
func _create_cards_for_player_hand_rpc():
	var player_hand_cards: Array[Card] = CardManager.create_cards(cards)
	for card in player_hand_cards:
		player_hand.discard_card(card)

@rpc("any_peer", "call_local", "reliable")
func _setup_player_turn(pid: int):
	if not multiplayer.get_unique_id() == pid: return
	start_local_play_turn()
	on_start_of_turn.emit()
	
func _on_next_turn_button_pressed() -> void:
	start_next_turn()
	
func start_local_play_turn() -> void:
	$next_turn_button.visible = true
	player_hand.fill_hand()
	
func end_local_play_turn() -> void:
	$next_turn_button.visible = false
	player_hand.clear_hand()
	CardShop.set_input_active(false)
	# Disable Rift Grid Manipulation as well
	reset_temporary_resources()
	
func is_my_turn() -> bool:
	return true
