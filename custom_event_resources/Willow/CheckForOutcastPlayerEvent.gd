extends EventResource
class_name CheckForOutcastPlayerEvent

#@export var amount: int = 1
@export var tinker_event : Array[EventResource]
@export var ashe_event : Array[EventResource]
var tinker_resource : CardResource = load("res://cards/Outcasts/Tinker.tres")
var ashe_resource : CardResource = load("res://cards/Outcasts/Ashe.tres")
#const card_to_place: int = 0

# This check can't be correct due to 
func on_execute() -> bool:
	var top_card : Card = RiftGrid.Instance.get_top_card(m_card_invoker.grid_pos)
	#print("The current top card is ", top_card.resource.title)
	if (top_card.resource.title == ashe_resource.title):
		for event in ashe_event:
			event.on_execute()
	if (top_card.resource.title == tinker_resource.title):
		for event in tinker_event:
			event.on_execute()
	return false
	
func required_events() -> Array[EventResource]:
	return []
