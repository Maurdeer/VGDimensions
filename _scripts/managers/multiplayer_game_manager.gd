extends GameManager
class_name MultiplayerGameManager
@onready var chat: Chat = $Chat
@onready var name_label: Label = $PlayerHandUI/name_label


var player_turn_queue: Array[int]
var curr_turn: int
var random_seed: int

func _ready() -> void:
	if multiplayer.is_server():
		GNM.all_players_loaded.connect(_start_game)
	CardManager.create_card(initial_quest_card)
	super._ready()
	
func _after_ready() -> void:
	name_label.text = GNM.player_info['name']
	initial_player_stats()
	GNM.player_loaded.rpc()

# Should be only invoked my the Server
func _start_game() -> void:
	if not multiplayer.is_server(): return
	chat.create_message.rpc("Game Will Start!")
	CardManager.create_card(initial_quest_card)
	setup_peers()
	setup_card_shop()
	setup_rift_grid()
	create_cards_for_player_hand()
	_setup_player_turn.rpc(player_turn_queue[curr_turn])

func start_next_turn() -> void:
	# End Current Player Turn
	end_local_play_turn()
	_start_next_turn.rpc()
	
@rpc("any_peer", "call_remote", "reliable")
func _set_up_each_peer(p_curr_turn: int, p_player_turn_queue: Array[int], p_random_seed: int) -> void:
	curr_turn = p_curr_turn
	player_turn_queue = p_player_turn_queue
	random_seed = p_random_seed
	rift_grid.pre_defined_seed = p_random_seed
	seed(p_random_seed)
	
@rpc("any_peer", "call_local", "reliable")
func _start_next_turn() -> void:
	on_end_of_turn.emit()
	curr_turn = (curr_turn + 1) % player_turn_queue.size()
	if not multiplayer.is_server(): return
	_setup_player_turn.rpc(player_turn_queue[curr_turn])
	
func create_cards_for_player_hand():
	_create_cards_for_player_hand_rpc.rpc()
	
@rpc("any_peer", "call_local", "reliable")
func _create_cards_for_player_hand_rpc():
	var player_hand_cards: Array[Card] = CardManager.create_cards_from_packs([initial_hand_card_pack])
	for card in player_hand_cards:
		player_hand.discard_card(card)
	#player_hand.fill_hand()
	player_hand.reshuffle_draw_pile()

@rpc("any_peer", "call_local", "reliable")
func _setup_player_turn(pid: int):
	if multiplayer.get_unique_id() == pid:
		start_local_play_turn()
	on_start_of_turn.emit()
	
func _on_next_turn_button_pressed() -> void:
	start_next_turn()
	
func start_local_play_turn() -> void:
	chat.create_message.rpc("[Server] Its %s's Turn!" % GNM.player_info['name'])
	next_turn_button.visible = true
	player_hand.fill_hand()
	
	
func end_local_play_turn() -> void:
	next_turn_button.visible = false
	player_hand.clear_hand()
	# Disable Rift Grid Manipulation as well
	reset_temporary_resources()
	
func is_my_turn() -> bool:
	return player_turn_queue.size() <= 0 or multiplayer.get_unique_id() == player_turn_queue[curr_turn]
	
func setup_card_shop():
	var shop_cards: Array[Card] = CardManager.create_cards_from_packs(shop_initial_packs)
	_setup_card_shop.rpc(CardManager.cards_to_ids(shop_cards))
	
func setup_peers():
	curr_turn = 0
	player_turn_queue.append(multiplayer.get_unique_id())
	for pid in multiplayer.get_peers():
		player_turn_queue.push_back(pid)
	random_seed = randi()
	rift_grid.pre_defined_seed = random_seed
	seed(random_seed)
	_set_up_each_peer.rpc(curr_turn, player_turn_queue, random_seed)

@rpc("any_peer", "call_local", "reliable")
func _setup_card_shop(shop_card_ids: Array[int]):
	CardShop.reset_shop_deck()
	CardShop.fill_shop_deck(CardManager.ids_to_cards(shop_card_ids))
	
@rpc("any_peer", "call_local", "reliable")
func _on_victory() -> void:
	var winner: bool = multiplayer.get_unique_id() == multiplayer.get_remote_sender_id()
	if winner:
		get_tree().change_scene_to_file("res://_scenes/win_screen.tscn")
	else:
		get_tree().change_scene_to_file("res://_scenes/lose_screen.tscn")
	
func game_victory() -> void:
	# only the winner calls this, so 
	_on_victory.rpc()
	
