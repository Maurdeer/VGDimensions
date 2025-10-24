extends EventResource
class_name SniperTowerDamageEvent

var amount : int = 1

func on_execute() -> bool:
	#var curr_pos : Vector2i = m_card_invoker.grid_pos
	var target : Card = RiftGrid.Instance.find_lowest_health()
	
	var target_pos : Vector2i = target.grid_pos
	var defeated : bool = target.damage(amount)
	if defeated: RiftGrid.Instance.draw_card(target_pos)
	return false
	
func required_events() -> Array[EventResource]:
	return []
