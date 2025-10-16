extends EventResource
class_name RotateCardEvent

@export var selection_type: SelectionEventResource.SelectionType
@export var left: bool
const target_card_at: int = 0
func on_execute():
	var new_dir: Card.CardDirection 
	if left:
		new_dir = (m_card_refs[target_card_at].dir - 1) % Card.CardDirection.size()
	else:
		new_dir = (m_card_refs[target_card_at].dir + 1) % Card.CardDirection.size()	
	RiftGrid.Instance.rotate_card(m_card_refs[target_card_at].grid_pos, new_dir)
	return false
	
func required_events() -> Array[EventResource]:
	var selection: SelectionEventResource = SelectionEventResource.new()
	selection.store_at = target_card_at
	selection.type = selection_type
	return [selection]
