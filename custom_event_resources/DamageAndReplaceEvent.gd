extends EventResource
class_name DamageAndReplaceEvent

@export var selection_type: SelectionEventResource.SelectionType = SelectionEventResource.SelectionType.RIFT
@export var amount: int = 0
@export var replacement_card : CardResource

const target_card_at: int = 0

func on_execute() -> bool:
	var selected_card: Card = m_card_refs[target_card_at]
	var selected_pos: Vector2i = selected_card.grid_pos
	if not RiftGrid.Instance.is_valid_pos(selected_card.grid_pos):
		return true
	
	var defeated: bool = m_card_refs[target_card_at].damage(amount)
	if defeated:
		if (replacement_card):
			var replacement = CardManager.create_card_locally(replacement_card, true)
			RiftGrid.Instance.place_card(selected_pos, replacement)
		if m_card_invoker.card_sm.is_state(CardStateMachine.StateType.IN_RIFT):
			var temp_location : Vector2i = m_card_invoker.grid_pos
			RiftGrid.Instance.move_card_to(selected_pos, m_card_invoker.grid_pos)
			RiftGrid.Instance.draw_card_if_empty(temp_location)
		if m_card_invoker.card_sm.is_state(CardStateMachine.StateType.IN_HAND):
			RiftGrid.Instance.place_card(selected_pos, m_card_invoker)
	return false
	
func required_events() -> Array[EventResource]:
	var selection: SelectionEventResource = SelectionEventResource.new()
	selection.store_at = target_card_at
	selection.type = selection_type
	return [selection]
	
