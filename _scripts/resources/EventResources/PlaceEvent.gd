extends EventResource
class_name PlaceEvent

@export var only_adjacent_cards: bool = false
@export var other_card_resource: CardResource

func execute(card_ref: Card) -> bool:
	var selected_card_pos: Vector2i
	
	if card_ref.card_sm.is_state(CardStateMachine.StateType.IN_HAND):
		selected_card_pos = await GridPositionSelector.Instance.player_select_card()
		if other_card_resource == null:
			RiftGrid.Instance.place_card(selected_card_pos, card_ref)
		else:
			var other_card = CardManager.create_card(other_card_resource, true)
			RiftGrid.Instance.place_card(selected_card_pos, other_card)
	elif card_ref.card_sm.is_state(CardStateMachine.StateType.IN_RIFT):
		if only_adjacent_cards:
			var filter: Callable = func(card):
				return (card.grid_pos - card_ref.grid_pos).length() == 1
			selected_card_pos = await GridPositionSelector.Instance.player_select_card_filter(filter)
		else:
			selected_card_pos = await GridPositionSelector.Instance.player_select_card()
		if other_card_resource == null:
			RiftGrid.Instance.move_card_to(selected_card_pos, card_ref.grid_pos)
			RiftGrid.Instance.fill_empty_decks()
		else:
			var other_card = CardManager.create_card(other_card_resource, true)
			RiftGrid.Instance.place_card(selected_card_pos, other_card)
	return true
