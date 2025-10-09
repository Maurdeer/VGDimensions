extends EventResource
class_name BurnEvent

func execute(card_ref: Card) -> bool:
	var selected_card_pos: Vector2i 
	# TODO: Add a selection event. It shouldn't be like this.
	# Do this.
	RiftGrid.Instance.burn_card(selected_card_pos)	
	return true
