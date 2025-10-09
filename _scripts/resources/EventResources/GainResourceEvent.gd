extends EventResource
class_name GainResourceEvent

@export var type: PlayerStatistics.ResourceType
@export var amount: int

func execute(_card_ref: Card) -> bool:
	PlayerStatistics.modify_resource(type, amount)
	if (type == PlayerStatistics.ResourceType.POLAROID):
		QuestManager.Instance.update_quest()
	return true
