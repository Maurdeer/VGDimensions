extends EventResource
class_name DiscardTypeEvent

@export var target_type: CardResource.CardType

const target_card_at: int = 0
func on_execute() -> bool:
	var selected_card: Card = m_card_refs[target_card_at]
	if not RiftGrid.Instance.is_valid_pos(selected_card.grid_pos) or not selected_card.resource.type == target_type:
		return true
	RiftGrid.Instance.discard_card_and_draw(selected_card)
	return false
	
func required_events() -> Array[EventResource]:
	var selection: SelectionEventResource = SelectionEventResource.new()
	selection.store_at = target_card_at
	selection.type = SelectionEventResource.SelectionType.RIFT
	return [selection]
	
