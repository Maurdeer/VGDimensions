extends EventResource
class_name PlaceEvent

func execute() -> void:
	GridPositionSelector.Instance.player_select_card()
	await GridPositionSelector.Instance.selected
	var selected_card_pos: Vector2i = GridPositionSelector.Instance.selected_pos
	card_ref.card_sm.transition_to_state(CardStateMachine.StateType.ON_RIFT)
	RiftGrid.Instance.place_card(selected_card_pos, card_ref)
	PlayerHand.Instance.remove_card_from_hand(card_ref)
