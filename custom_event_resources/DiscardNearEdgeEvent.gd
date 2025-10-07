extends EventResource
class_name DiscardNearEdgeEvent

func execute(card_ref: Card) -> bool:
	var on_edge: bool = card_ref.grid_pos.y == RiftGrid.Instance.rift_grid_height - 1 or \
	card_ref.grid_pos.y == 0 or \
	card_ref.grid_pos.x == RiftGrid.Instance.rift_grid_width - 1 or \
	card_ref.grid_pos.x == 0
	
	if not on_edge: return false
	RiftGrid.Instance.discard_card(card_ref.grid_pos)
	return true
