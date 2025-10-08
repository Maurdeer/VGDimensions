extends EventResource
class_name BurnEvent

@export var amount: int

func execute(card_ref: Card) -> bool:
	var selected_card_pos: Vector2i 
	selected_card_pos = await GridPositionSelector.Instance.player_select_card()
	RiftGrid.Instance.burn_card(selected_card_pos)
	return true
