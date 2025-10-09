extends EventResource
class_name BurnStatusEvent

var count = 0

func execute(card_ref: Card) -> bool:
	#var selected_card_pos: Vector2i 
	# TODO: Add a selection event. It shouldn't be like this.
	# Do this.
	#print("Burn Status Event Triggered Properly")
	print(card_ref.grid_pos)
	RiftGrid.Instance.damage_card(card_ref.grid_pos, 1)
	count += 1
	if (count >= 2):
		card_ref.remove(self)
	return true
