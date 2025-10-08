extends EventResource
class_name DiscardAndReplaceEvent

@export var adjacent_only: bool
@export var deal_damage: bool = true
@export var damage_amount: int = 1

func execute(card_ref: Card) -> bool:
	var selected_pos: Vector2i
	if adjacent_only:
		var filter: Callable = func(card):
				return (card.grid_pos - card_ref.grid_pos).length() == 1
		selected_pos = await GridPositionSelector.Instance.player_select_card_filter(filter)
	else:
		selected_pos = await GridPositionSelector.Instance.player_select_card_filter()
	
	var defeated: bool = await RiftGrid.Instance.damage_card(selected_pos, damage_amount)
	
	if card_ref.card_sm.is_state(CardStateMachine.StateType.IN_RIFT):
		if defeated:
			var card_pos: Vector2i = card_ref.grid_pos
			RiftGrid.Instance.move_card_to(selected_pos, card_ref.grid_pos)
			RiftGrid.Instance.draw_card(card_pos)
	else:
		if defeated:
			RiftGrid.Instance.place_card(selected_pos, card_ref)
		else:
			PlayerHand.Instance.discard_card(card_ref)
	return true
