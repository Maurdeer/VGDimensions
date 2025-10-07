extends EventResource
class_name MultiEvent

var events: Array[EventResource]

func execute(card_ref: Card) -> bool:
	# TODO: determine how to succed or fail with this one
	for event in events:
		await event.execute(card_ref)
		
	return true
