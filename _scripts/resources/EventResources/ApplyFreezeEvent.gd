extends EventResource
class_name ApplyFreezeEvent

@export var _passive_event : EventResource
@export var amount : int

func on_execute() -> bool:
	return true
	
func required_events() -> Array[EventResource]:
	return []
