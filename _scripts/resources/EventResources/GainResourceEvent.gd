extends EventResource
class_name GainResourceEvent

@export var type: PlayerStatistics.ResourceType
@export var amount: int

func on_execute() -> bool:
	if GameManager.Instance.is_my_turn():
		PlayerStatistics.modify_resource(type, amount)
	return false

func required_events() -> Array[EventResource]:
	return []
