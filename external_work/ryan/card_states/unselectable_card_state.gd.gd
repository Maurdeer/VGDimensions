extends CardState
class_name UnselectableCardState


func enter() -> void:
	card_visualizer.modulate.a = 0.5
	
func exit() -> void:
	card_visualizer.modulate.a = 1
