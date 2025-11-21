extends EventResource
class_name PolaroidQuestProgressEvent

@export var necessaryPolaroidAmount: int

func on_execute() -> bool:
	return true
	
func required_events() -> Array[EventResource]:
	return []
