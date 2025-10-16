extends EventResource
class_name FreezeStatusEvent


var count = 0

func on_execute() -> bool:
	return true
	
func required_events() -> Array[EventResource]:
	return []
