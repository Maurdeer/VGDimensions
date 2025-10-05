extends CardState
class_name InteractableCardState

func enter() -> void:
	card.flip_reveal()
	dnd.interactable = true
