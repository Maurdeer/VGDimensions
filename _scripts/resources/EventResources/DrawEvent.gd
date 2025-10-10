extends EventResource
class_name DrawEvent

@export var amount : int

func execute(_card_ref: Card) -> bool:
	for i in amount:
		GameManager.Instance.player_hand.draw_card_to_hand()
	
	return true
