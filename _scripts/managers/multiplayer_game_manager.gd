extends GameManager
class_name MultiplayerGameManager
@onready var chat: Chat = $Chat
@onready var name_label: Label = $PlayerHandUI/TextureRect/name_label

var player_turn_queue: Array[int]
var curr_turn: int
var random_seed: int

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
	#CardManager.create_card(initial_quest_card)
	setup_peers()
	setup_card_shop()
	create_cards_for_player_hand()
	setup_wheel()
	dimension_select() # Will begin our loop
	
func setup_wheel() -> void:
	_setup_wheel_rpc.rpc()
	
@rpc("any_peer", "call_local", "reliable")
func _setup_wheel_rpc() -> void:
	super.setup_wheel()
	
func dimension_select():
	selected_dimension = rigged_dimensions.pick_random()
	rigged_dimensions.erase(selected_dimension)
	launch_wheel_rpc.rpc(selected_dimension)

@rpc("any_peer", "call_local", "reliable")
func launch_wheel_rpc(dimension_picked: String):
	selected_dimension = dimension_picked
	rift_grid.clear_grid()
	#await the_wheel.descend()
	the_wheel.descend(selected_dimension)
	var quest_card = CardManager.create_card_locally(dimension_dictionary[selected_dimension].quest_card, false)
	QuestManager.Instance.add_quest(quest_card)
	await the_wheel.wheel_done
	QuestManager.Instance.reveal_quest()
	await get_tree().create_timer(2).timeout
	the_wheel.ascend()
	
	if multiplayer.is_server():
		setup_dimension()
	
	AudioManager.play_music(dimension_dictionary[selected_dimension].music)
	await get_tree().create_timer(4).timeout
	the_wheel.dimension_list.erase(selected_dimension)
	
func setup_dimension():
	setup_rift_grid()
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
	await RiftGrid.Instance.on_end_of_new_turn()
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
	await RiftGrid.Instance.on_start_of_new_turn()
	
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
		
@rpc("any_peer", "call_local", "reliable")
func _on_quest_completed_rpc() -> void:
	var winner: bool = multiplayer.get_unique_id() == multiplayer.get_remote_sender_id()
	QuestManager.Instance.remove_quest()
	if winner:
		PlayerStatistics.dimensions_won += 1
		if PlayerStatistics.dimensions_won >= 2:
			game_victory()
			return
			
	if is_my_turn():
		end_local_play_turn()
		
	rift_grid.clear_grid()
	
	if multiplayer.is_server():
		dimension_select()
	
func game_victory() -> void:
	# only the winner calls this, so 
	_on_victory.rpc()
	
func on_quest_completed() -> void:
	_on_quest_completed_rpc.rpc()
	
