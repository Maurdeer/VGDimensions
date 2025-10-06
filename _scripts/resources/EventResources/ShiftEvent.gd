extends EventResource
class_name ShiftEvent

enum Direction {HORIZONTAL, VERTICAL}
@export var shift_direction: Direction
@export var amount: int = 1

func execute(_card_ref: Card) -> void:
	var shift_from: Vector2i = await GridPositionSelector.Instance.player_select_card()
	match(shift_direction):
		Direction.HORIZONTAL:
			RiftGrid.Instance.shift_decks_horizontally(shift_from, amount)
		Direction.VERTICAL:
			RiftGrid.Instance.shift_decks_vertically(shift_from, amount)
