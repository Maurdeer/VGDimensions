extends EventResource
class_name DiscardSelfEvent

@export var other_card: CardResource

func on_execute() -> bool:
	return true
	
func required_events() -> Array[EventResource]:
	return []
