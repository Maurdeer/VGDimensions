extends EventResource
class_name DiscardAndReplaceEvent

@export var selection_type: SelectionEventResource.SelectionType = SelectionEventResource.SelectionType.RIFT
@export var replacement_card : CardResource

const target_card_at: int = 0
func on_execute() -> bool:
	var selected_card: Card = m_card_refs[target_card_at]
	if not RiftGrid.Instance.is_valid_pos(selected_card.grid_pos):
		return true
	if (replacement_card == null):
		RiftGrid.Instance.discard_card_and_draw(selected_card)
	else:
		var selected_pos : Vector2i = selected_card.grid_pos
		RiftGrid.Instance.discard_card(selected_card)
		var source_card = CardManager.create_card_locally(replacement_card, true)
		RiftGrid.Instance.place_card(selected_pos, source_card)
	
	
	return false
	
func required_events() -> Array[EventResource]:
	var selection: SelectionEventResource = SelectionEventResource.new()
	selection.store_at = target_card_at
	selection.type = selection_type
	return [selection]
	
