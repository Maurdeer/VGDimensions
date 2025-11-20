extends RiftGrid
class_name NetworkedRiftGrid

# I just turn every function in RiftGrid to an rpc call :p
@export var local_rift_grid: LocalRiftGrid
@onready var chat: Chat = $"../Chat"

#region Generate New Cards
func generate_new_grid(cards: Array[Card], rift_width: int, rift_height: int) -> void:
	chat.create_message.rpc("[Server] Generate new Grid!")
	_generate_new_grid.rpc(CardManager.cards_to_ids(cards), rift_width, rift_height)
	
@rpc("any_peer", "call_local", "reliable")
func _generate_new_grid(card_ids: Array[int], rift_width: int, rift_height: int):
	local_rift_grid.generate_new_grid(CardManager.ids_to_cards(card_ids), rift_width, rift_height)
#endregion
#region Draw Card
func draw_card(draw_to: Vector2i) -> void:
	chat.create_message.rpc("[Server] %s Drew to %s" % [GNM.player_info['name'], draw_to])
	_draw_card.rpc(draw_to)
	
@rpc("any_peer", "call_local", "reliable")
func _draw_card(draw_to: Vector2i) -> void:
	local_rift_grid.draw_card(draw_to)
#endregion
#region Place Card
func place_card(place_at: Vector2i, new_card: Card) -> void:
	chat.create_message.rpc("[Server] %s Placed %s at %s" % [GNM.player_info['name'], new_card.resource.title, place_at])
	_place_card.rpc(place_at, new_card.card_id)
	
@rpc("any_peer", "call_local", "reliable")
func _place_card(place_at: Vector2i, new_card_id: int) -> void:
	local_rift_grid.place_card(place_at, CardManager.get_card_by_id(new_card_id))
#endregion
#region Place Card Under
func place_card_under(place_at: Vector2i, new_card: Card) -> void:
	chat.create_message.rpc("[Server] %s Placed %s under card at %s" % [GNM.player_info['name'], new_card.resource.title, place_at])
	_place_card_under.rpc(place_at, new_card.card_id)
@rpc("any_peer", "call_local", "reliable")
func _place_card_under(place_at: Vector2i, new_card_id: int) -> void:
	local_rift_grid.place_card_under(place_at, CardManager.get_card_by_id(new_card_id))
#endregion
#region Place Deck From Rift
func place_deck_from_rift(place_at: Vector2i, from_deck_pos: Vector2i) -> void:
	_place_deck_from_rift.rpc(place_at, from_deck_pos)
@rpc("any_peer", "call_local", "reliable")
func _place_deck_from_rift(place_at: Vector2i, from_deck_pos: Vector2i) -> void:
	local_rift_grid.place_deck_from_rift(place_at, from_deck_pos)
#endregion
#region Place Cards
func place_cards(place_at: Vector2i, cards: Array[Card]) -> void:
	_place_cards.rpc(place_at, CardManager.cards_to_ids(cards))
	
@rpc("any_peer", "call_local", "reliable")
func _place_cards(place_at: Vector2i, card_ids: Array[int]) -> void:
	local_rift_grid.place_cards(place_at, CardManager.ids_to_cards(card_ids))
#endregion
#region Place Cards Under
func place_cards_under(place_at: Vector2i, cards: Array[Card]) -> void:
	_place_cards_under.rpc(place_at, CardManager.cards_to_ids(cards))
	
@rpc("any_peer", "call_local", "reliable")
func _place_cards_under(place_at: Vector2i, card_ids: Array[int]) -> void:
	local_rift_grid.place_cards_under(place_at, CardManager.ids_to_cards(card_ids))
#endregion
#region Discard Card
#func discard_card(discard_from: Vector2i, deck_pos: int = 0) -> void:
	#chat.create_message.rpc("[Server] %s discarded card at %s" % [GNM.player_info['name'], discard_from])
	#_discard_card.rpc(discard_from, deck_pos)
	#
#@rpc("any_peer", "call_local", "reliable")
#func _discard_card(discard_from: Vector2i, deck_pos: int) -> void:
	#local_rift_grid.discard_card(discard_from, deck_pos)
##endregion
##region Discard Card and Draw
#func discard_card_and_draw(discard_from: Vector2i, deck_pos: int = 0, draw_when_empty: bool = true) -> void:
	#chat.create_message.rpc("[Server] %s discarded card and drew at %s" % [GNM.player_info['name'], discard_from])
	#_discard_card_and_draw.rpc(discard_from, deck_pos, draw_when_empty)
	#
#@rpc("any_peer", "call_local", "reliable")
#func _discard_card_and_draw(discard_from: Vector2i, deck_pos: int, draw_when_empty: bool) -> void:
	#local_rift_grid.discard_card_and_draw(discard_from, deck_pos, draw_when_empty)
#endregion
#region Discard Entire Deck
func discard_entire_deck(discard_from: Vector2i):
	_discard_entire_deck.rpc(discard_from)
	
@rpc("any_peer", "call_local", "reliable")
func _discard_entire_deck(discard_from: Vector2i):
	local_rift_grid.discard_entire_deck(discard_from)
#endregion
#region Move Card To
func move_card_to(move_to: Vector2i, move_from: Vector2i) -> void:
	chat.create_message.rpc("[Server] %s Moved a card from %s to %s" % [GNM.player_info['name'], move_from, move_to])
	_move_card_to.rpc(move_to, move_from)
	
@rpc("any_peer", "call_local", "reliable")
func _move_card_to(move_to: Vector2i, move_from: Vector2i) -> void:
	local_rift_grid.move_card_to(move_to, move_from)
#endregion
#region Move Card To Under
func move_card_to_under(move_to: Vector2i, move_from: Vector2i) -> void:
	chat.create_message.rpc("[Server] %s Moved a card from %s under a card at %s" % [GNM.player_info['name'], move_from, move_to])
	_move_card_to.rpc(move_to, move_from)
	
@rpc("any_peer", "call_local", "reliable")
func _move_card_to_under(move_to: Vector2i, move_from: Vector2i) -> void:
	local_rift_grid.move_card_to_under(move_to, move_from)
#endregion
#region Swap Cards
func swap_cards(card_a_pos: Vector2i, card_b_pos: Vector2i):
	chat.create_message.rpc("[Server] %s Swap a card from %s with a card from %s" % [GNM.player_info['name'], card_a_pos, card_b_pos])
	_swap_cards.rpc(card_a_pos, card_b_pos)
	
@rpc("any_peer", "call_local", "reliable")
func _swap_cards(card_a_pos: Vector2i, card_b_pos: Vector2i):
	local_rift_grid.swap_cards(card_a_pos, card_b_pos)
#endregion
#region Swap Decks
func swap_decks(deck_a_pos: Vector2i, deck_b_pos: Vector2i):
	_swap_decks.rpc(deck_a_pos, deck_b_pos)
	
@rpc("any_peer", "call_local", "reliable")
func _swap_decks(deck_a_pos: Vector2i, deck_b_pos: Vector2i):
	local_rift_grid.swap_decks(deck_a_pos, deck_b_pos)
#endregion
#region Shuffle Card Back In Deck
func shuffle_card_back_in_deck(shuffle_card: Card, target_deck: Deck):
	_shuffle_card_back_in_deck.rpc(shuffle_card, target_deck)
	
@rpc("any_peer", "call_local", "reliable")
func _shuffle_card_back_in_deck(shuffle_card: Card, target_deck: Deck):
	local_rift_grid.shuffle_card_back_in_deck(shuffle_card, target_deck)
#endregion
#region Shift Decks Horizontally
func shift_decks_horizontally(start_pos: Vector2i, offset: int):
	_shift_decks_horizontally.rpc(start_pos, offset)
@rpc("any_peer", "call_local", "reliable")
func _shift_decks_horizontally(start_pos: Vector2i, offset: int):
	local_rift_grid.shift_decks_horizontally(start_pos, offset)
#endregion
#region Shift Decks Vertically
func shift_decks_vertically(start_pos: Vector2i, offset: int):
	_shift_decks_vertically.rpc(start_pos, offset)
@rpc("any_peer", "call_local", "reliable")
func _shift_decks_vertically(start_pos: Vector2i, offset: int):
	local_rift_grid.shift_decks_vertically(start_pos, offset)
#endregion
#region Loops Card Horizontally
func loop_cards_horizontally(startY: int, leftNotRight: bool, amount: int):
	_loop_cards_horizontally.rpc(startY, leftNotRight, amount)
@rpc("any_peer", "call_local", "reliable")
func _loop_cards_horizontally(startY: int, leftNotRight: bool, amount: int):
	local_rift_grid.loop_cards_horizontally(startY, leftNotRight, amount)
#endregion
#region Loop Cards Vertically
func loop_cards_vertically(startX: int, upNotDown: bool, amount: int):
	_loop_cards_vertically.rpc(startX, upNotDown, amount)
@rpc("any_peer", "call_local", "reliable")
func _loop_cards_vertically(startX: int, upNotDown: bool, amount: int):
	local_rift_grid.loop_cards_vertically(startX, upNotDown, amount)
#endregion
#region Damage Card
#func damage_card(card_pos: Vector2i, amount: int) -> bool:
	#_damage_card.rpc(card_pos, amount)
	#return await _damage_card(card_pos, amount)
	
#@rpc("any_peer", "call_remote", "reliable")
#func _damage_card(card_pos: Vector2i, amount: int) -> bool:
	#return await local_rift_grid.damage_card(card_pos, amount)
#endregion
#region Burn Card
func burn_card(card_pos: Vector2i) -> bool:
	_burn_card.rpc(card_pos)
	return _burn_card(card_pos)
	
@rpc("any_peer", "call_remote", "reliable")
func _burn_card(card_pos: Vector2i) -> bool:
	return local_rift_grid.burn_card(card_pos)
#endregion
#region Freeze Card
func freeze_card(card_pos: Vector2i) -> bool:
	_freeze_card.rpc(card_pos)
	return _freeze_card(card_pos)
@rpc("any_peer", "call_remote", "reliable")
func _freeze_card(card_pos: Vector2i) -> bool:
	return local_rift_grid.freeze_card(card_pos)
#endregion
	
#====================== Section of iterating over the entire grid =====================

#region Fill Empty Decks
func fill_empty_decks() -> void:
	_fill_empty_decks.rpc()
	
@rpc("any_peer", "call_local", "reliable")
func _fill_empty_decks() -> void:
	local_rift_grid.fill_empty_decks()
#endregion
#region On Start Of New Turn
func _on_start_of_new_turn() -> void:
	_on_start_of_new_turn_rpc.rpc()
@rpc("any_peer", "call_local", "reliable")
func _on_start_of_new_turn_rpc() -> void:
	local_rift_grid._on_start_of_new_turn()
#endregion
#region On End Of New Turn
func _on_end_of_new_turn() -> void:
	_on_end_of_new_turn_rpc.rpc()
@rpc("any_peer", "call_local", "reliable")
func _on_end_of_new_turn_rpc() -> void:
	local_rift_grid._on_end_of_new_turn()
#endregion
#region On State of Grid Change
func _on_state_of_grid_change() -> void:
	_on_state_of_grid_change_rpc.rpc()
@rpc("any_peer", "call_local", "reliable")
func _on_state_of_grid_change_rpc() -> void:
	local_rift_grid._on_state_of_grid_change()
#endregion
#region Double Rift Deck
func _double_rift_deck() -> void:
	_double_rift_deck_rpc.rpc()
@rpc("any_peer", "call_local", "reliable")
func _double_rift_deck_rpc() -> void:
	local_rift_grid._double_rift_deck()
#endregion

# Unique to this script:
# Security Check if the RiftGrid grid and Draw Deck states are the same in all peers
func integrity_check() -> void:
	pass
