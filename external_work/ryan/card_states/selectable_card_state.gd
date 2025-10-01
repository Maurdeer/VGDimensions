extends CardState
class_name SelectableCardState

func enter() -> void:
	card.flip_reveal()

func clicked_on() -> void:
	card.selected.emit(card.grid_pos)
