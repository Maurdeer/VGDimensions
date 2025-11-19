extends CardState
class_name SelectableCardState

func enter() -> void:
	# (RYAN): This is bad, instead do something more hireactly imo dude
	gridcard_visualizer.visible = true
	gridcard_back.visible = true
	gridcard_shape.visible = true
	
	card_visualizer.visible = false
	card_back.visible = false
	card_shape.visible = false
	
	card.interactable = true
	card.flip_reveal()

func clicked_on() -> void:
	card.selected.emit(card)
