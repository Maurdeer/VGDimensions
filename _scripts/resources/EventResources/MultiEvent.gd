extends EventResource
class_name MultiEvent

@export var events: Array[EventResource]

func on_execute() -> bool:
	return false
	
func required_events() -> Array[EventResource]:
	return events
