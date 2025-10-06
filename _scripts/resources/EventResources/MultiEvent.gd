extends EventResource
class_name MultiEvent

var events: Array[EventResource]

func execute(card_ref: Card) -> void:
	for event in events:
		event.execute(card_ref)
