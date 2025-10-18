extends EventResource
class_name DiscardEvent

@export var selection_type: SelectionEventResource.SelectionType = SelectionEventResource.SelectionType.RIFT

const target_card_at: int = 0
func on_execute() -> bool:
	var selected_card: Card = m_card_refs[target_card_at]
	if not RiftGrid.Instance.is_valid_pos(selected_card.grid_pos):
		return true
	RiftGrid.Instance.discard_card_and_draw(selected_card)
	return false
	
func required_events() -> Array[EventResource]:
	var selection: SelectionEventResource = SelectionEventResource.new()
	selection.store_at = target_card_at
	selection.type = selection_type
	return [selection]
	
