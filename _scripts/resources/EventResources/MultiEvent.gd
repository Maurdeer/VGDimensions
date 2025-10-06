extends EventResource
class_name MultiEvent

var events: Array[EventResource]

func execute() -> void:
	for event in events:
		event.execute()
