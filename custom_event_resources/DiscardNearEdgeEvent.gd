extends EventResource
class_name DiscardNearEdgeEvent

func on_execute() -> bool:
	return true
	
func required_events() -> Array[EventResource]:
	return []
