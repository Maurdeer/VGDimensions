extends EventResource
class_name ShiftEvent

enum Direction {HORIZONTAL, VERTICAL}
@export var shift_direction: Direction
@export var amount: int = 1
@export var shift_all: bool = false

func on_execute() -> bool:
	return true
