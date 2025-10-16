extends EventResource
class_name DiscardAndReplaceEvent

@export var adjacent_only: bool
@export var deal_damage: bool = true
@export var damage_amount: int = 1

func on_execute() -> bool:
	return true

func required_events() -> Array[EventResource]:
	return []
