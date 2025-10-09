extends EventResource
class_name FreezeStatusEvent


var count = 0

func execute(card_ref: Card) -> bool:
	#var selected_card_pos: Vector2i 
	# TODO: Add a selection event. It shouldn't be like this.
	# Do this.
	if (count >= 1):
		card_ref.interactable = true
		card_ref.remove(self)
		
	count += 1

	return true
