extends EventResource
class_name ShiftEvent

enum Direction {HORIZONTAL, VERTICAL}
@export var shift_direction: Direction
@export var amount: int = 1
@export var shift_all: bool = false

func execute(_card_ref: Card) -> bool:
	var shift_from: Vector2i = await GridPositionSelector.Instance.player_select_card()
	if (shift_all):
		match(shift_direction):
			Direction.HORIZONTAL:
				shift_from.x = 0
			Direction.VERTICAL:
				shift_from.y = 0
	match(shift_direction):
		Direction.HORIZONTAL:
			RiftGrid.Instance.shift_decks_horizontally(shift_from, amount)
		Direction.VERTICAL:
			RiftGrid.Instance.shift_decks_vertically(shift_from, amount)
			
	return true
