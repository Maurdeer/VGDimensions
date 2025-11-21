extends EventResource
class_name CheckForPlayerEvent

#@export var amount: int = 1
@export var bullet_spawn : EventResource
var player_resource : CardResource = load("res://cards/Willow/TheWanderer.tres")
#const card_to_place: int = 0

func on_execute() -> bool:
	var adjacent_cards = RiftGrid.Instance.get_adjacent_cards(m_card_invoker.grid_pos)
	for card in adjacent_cards:
		if card.resource.title == player_resource.title:
			bullet_spawn.on_execute()
	return false
	
func required_events() -> Array[EventResource]:
	return []
