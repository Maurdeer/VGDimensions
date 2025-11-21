extends EventResource
class_name GainResourceEvent

@export var type: PlayerStatistics.ResourceType
@export var amount: int

func on_execute() -> bool:
	#AudioManager.play_sfx()
	if GameManager.Instance.is_my_turn():
		PlayerStatistics.modify_resource(type, amount)
		RiftGrid.Instance.emit_global_event(PassiveEventResource.GlobalEvent.ON_GAIN_RESOURCE, m_card_invoker)
	return false

func required_events() -> Array[EventResource]:
	return []
