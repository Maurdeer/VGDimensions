extends EventResource
class_name PlaceEvent

@export var only_adjacent_cards: bool = false
@export var other_card_resource: CardResource

func on_execute() -> bool:
	return true

func required_events() -> Array[EventResource]:
	return []
