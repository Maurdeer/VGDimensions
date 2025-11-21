extends EventResource
class_name DrawEvent

@export var amount : int

func on_execute() -> bool:
	if GameManager.Instance.is_my_turn():
		for i in range(amount):
			GameManager.Instance.player_hand.draw_card_to_hand()
	return false
	
func required_events() -> Array[EventResource]:
	return []
