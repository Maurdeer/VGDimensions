extends EventResource
class_name AssertIsEnemyOrAllyEvent

@export var event_to_do : EventResource

func on_execute() -> bool:
	
	return false
	
func required_events() -> Array[EventResource]:
	return []
	
