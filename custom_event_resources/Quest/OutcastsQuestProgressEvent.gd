extends EventResource
class_name OutcastsQuestProgressEvent

var ashe_door_resource : CardResource = load("res://cards/Outcasts/AsheDoor.tres")
var tinker_door_resource: CardResource = load("res://cards/Outcasts/TinkerDoor.tres")
var ashe_resource : CardResource = load("res://cards/Outcasts/Ashe.tres")
var tinker_resource : CardResource = load("res://cards/Outcasts/Tinker.tres")
var has_triggered : bool = false

var ashe_door_card : Card
var tinker_door_card : Card
func on_execute() -> bool:
	var calling_card : Card = m_card_invoker
	
	# Checks to grab the current Ashe and TInker Doors
	if (calling_card.resource.title == ashe_door_resource.title):
		ashe_door_card = calling_card
	if (calling_card.resource.title == tinker_door_resource.title):
		tinker_door_card = calling_card
	
	# Safety checks so that cards that aren't on the rift can't be queried
	if (ashe_door_card == null or tinker_door_card == null):
		return false
	if (ashe_door_card.grid_pos == Vector2i(-1, -1) or \
	tinker_door_card.grid_pos == Vector2i(-1, -1)):
		return false
		
	if GameManager.Instance.is_my_turn():
		if (not has_triggered):
			var ashe_attempt : Card= RiftGrid.Instance.get_top_card(ashe_door_card.grid_pos)
			var tinker_attempt : Card = RiftGrid.Instance.get_top_card(tinker_door_card.grid_pos)
			if (ashe_attempt.resource.title == ashe_resource.title \
				and tinker_attempt.resource.title == tinker_resource.title):
					has_triggered = true
					MultiplayerGameManager.Instance.on_quest_completed()
	return false
	
func required_events() -> Array[EventResource]:
	return []
