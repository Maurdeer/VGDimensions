extends EventResource
class_name ApartmentEvent

@export var type: PlayerStatistics.ResourceType
@export var amount: int

func on_execute() -> bool:
	if GameManager.Instance.is_my_turn() && m_card_invoker.can_activate:
		PlayerStatistics.modify_resource(type, amount)
		m_card_invoker.can_activate = false
	print(PlayerStatistics.tetra_city_coins)
	return false

func required_events() -> Array[EventResource]:
	return []
