extends EventResource
class_name PlaceEvent

@export var only_adjacent_cards: bool = false

func execute(card_ref: Card) -> bool:
	var in_hand: bool = card_ref.grid_pos.x < 0 or card_ref.grid_pos.y < 0
	var selected_card_pos: Vector2i
	if in_hand:
		selected_card_pos = await GridPositionSelector.Instance.player_select_card()
		RiftGrid.Instance.place_card(selected_card_pos, card_ref)
	else:
		# In Rift
		if only_adjacent_cards:
			var filter: Callable = func(card):
				return (card.grid_pos - card_ref.grid_pos).length() == 1
			selected_card_pos = await GridPositionSelector.Instance.player_select_card_filter(filter)
		else:
			selected_card_pos = await GridPositionSelector.Instance.player_select_card()
		RiftGrid.Instance.place_card(selected_card_pos, RiftGrid.Instance.move_card(card_ref.grid_pos))
		RiftGrid.Instance.fill_empty_decks()
	return true
		
