extends CardState
class_name UnselectableCardState


func enter() -> void:
	card.modulate.a = 0.5
	dnd.interactable = false
	
func exit() -> void:
	super.exit()
	card.modulate.a = 1
	dnd.interactable = true
