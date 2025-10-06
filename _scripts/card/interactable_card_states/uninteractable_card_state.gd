extends CardState
class_name UninteractableCardState

func enter() -> void:
	#card.flip_hide()
	card.interactable = false
