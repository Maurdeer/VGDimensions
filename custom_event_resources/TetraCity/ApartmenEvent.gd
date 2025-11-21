extends EventResource
class_name ApartmentEvent

@export var type: PlayerStatistics.ResourceType
@export var amount: int

func on_execute() -> bool:
	if GameManager.Instance.is_my_turn():
		if m_card_invoker.can_activate:
			PlayerStatistics.modify_resource(type, amount)
			m_card_invoker.can_activate = false
		else:
			#Refund the player if the action could not be activated
			PlayerStatistics.modify_resource(PlayerStatistics.ResourceType.ACTION, 1)
	print(PlayerStatistics.tetra_city_coins)
	return false

func required_events() -> Array[EventResource]:
	return []
