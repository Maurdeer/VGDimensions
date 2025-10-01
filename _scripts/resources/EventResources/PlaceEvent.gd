extends EventResource
class_name PlaceEvent

func execute() -> void:
	var selected_card_pos: Vector2i = await GridPositionSelector.Instance.player_select_card()
	card_ref.card_sm.transition_to_state(CardStateMachine.StateType.ON_RIFT)
	RiftGrid.Instance.place_card(selected_card_pos, card_ref)
	PlayerHand.Instance.remove_card_from_hand(card_ref)
