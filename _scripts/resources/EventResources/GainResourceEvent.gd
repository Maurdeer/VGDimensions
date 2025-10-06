extends EventResource
class_name GainResourceEvent

@export var type: PlayerStatistics.ResourceType
@export var amount: int

func execute() -> void:
	PlayerStatistics.modify_base_resource(type, amount)
