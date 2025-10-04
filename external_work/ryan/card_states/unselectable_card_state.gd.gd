extends CardState
class_name UnselectableCardState


func enter() -> void:
	card.modulate.a = 0.5
	
func exit() -> void:
	card.modulate.a = 1
