extends EventResource
class_name ShiftEvent

enum Direction {HORIZONTAL, VERTICAL}
@export var shift_direction: Direction
@export var inverse: bool

func execute() -> void:
	var shift_from: Vector2i = await GridPositionSelector.Instance.player_select_card()
	match(shift_direction):
		Direction.HORIZONTAL:
			RiftGrid.Instance.shift_decks_horizontally(shift_from, inverse, 1)
		Direction.VERTICAL:
			RiftGrid.Instance.shiftCardsVertical(shift_from, inverse, 1)
