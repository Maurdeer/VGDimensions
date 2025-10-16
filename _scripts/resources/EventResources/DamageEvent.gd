extends EventResource
class_name DamageEvent

@export var target_card: SelectionEventResource.SelectionType
@export var amount: int

const target_card_at: int = 0
func on_execute() -> bool:
	var selected_card_pos = m_card_refs[target_card_at].grid_pos
	if not RiftGrid.Instance.is_valid_pos(selected_card_pos):
		return true
	var defeated: bool = await RiftGrid.Instance.damage_card(selected_card_pos, amount)
	if defeated: RiftGrid.Instance.draw_card(selected_card_pos)
	return false
	
func required_events() -> Array[EventResource]:
	var selection: SelectionEventResource = SelectionEventResource.new()
	selection.store_at = target_card_at
	selection.type = target_card
	return [selection]
