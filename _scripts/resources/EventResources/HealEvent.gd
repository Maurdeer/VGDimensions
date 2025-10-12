extends EventResource
class_name HealEvent

@export var self_heal: bool = false
@export var health_amount: int
@export var cap_at_starting_hp: bool

func on_execute() -> bool:
	return true
