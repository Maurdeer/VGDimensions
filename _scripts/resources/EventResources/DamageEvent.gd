extends EventResource
class_name DamageEvent

@export var amount: int
@export var target_card_at: int
func on_execute() -> bool:
	var selected_card_pos = m_card_refs[target_card_at].grid_pos
	if not RiftGrid.Instance.is_valid_pos(selected_card_pos):
		return true
	var defeated: bool = await RiftGrid.Instance.damage_card(selected_card_pos, amount)
	if defeated: RiftGrid.Instance.draw_card(selected_card_pos)
	return false
