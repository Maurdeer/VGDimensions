extends EventResource
class_name GainResourceEvent

@export var type: PlayerStatistics.ResourceType
@export var amount: int

func on_execute() -> bool:
	return true

func required_events() -> Array[EventResource]:
	return []
