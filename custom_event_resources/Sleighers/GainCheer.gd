extends EventResource
class_name GainCheer

@export var amount: int

const target_card_at: int = 0
func on_execute() -> bool:
	var position = m_card_invoker.grid_pos
	var card = RiftGrid.Instance.get_top_card(position)
	if card.sleighers_team != null:
		PlayerStatistics.modify_resource(PlayerStatistics.ResourceType.CHEER, amount, card.sleighers_team)
	print(PlayerStatistics.sleighers_cheer)
	return false

func required_events() -> Array[EventResource]:
	return []
