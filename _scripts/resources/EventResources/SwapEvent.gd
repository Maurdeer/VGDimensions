extends EventResource
class_name SwapEvent

@export var first_card_is_calling_card: bool
@export var adjacent_only: bool

func on_execute() -> bool:
	return true
