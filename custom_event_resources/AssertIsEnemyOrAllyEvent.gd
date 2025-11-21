extends EventResource
class_name AssertIsEnemyOrAllyEvent

@export var events_to_do : Array[EventResource]

func on_execute() -> bool:
	if ((m_card_invoker.resource.type == CardResource.CardType.ENEMY or \
		m_card_invoker.resource.type == CardResource.CardType.ALLY)):
			# TODO: Can do this through Multi Events, just rely on required events instead
			for event in events_to_do:
				event.on_execute()
	return false
	
func required_events() -> Array[EventResource]:
	return []
	
