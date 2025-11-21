extends EventResource
class_name ChangeTeam

#Bug: If a player attacks a structure they own, it switches back to neutral.
const target_card_at: int = 0
func on_execute() -> bool:
	var card = m_card_invoker
	if card.hp <= 0 and GameManager.Instance.is_my_turn():
		card.hp = card.resource.starting_hp
		if card.sleighers_team == PlayerStatistics.SleighersTeam.NEUTRAL:
			card.sleighers_team = PlayerStatistics.sleighers_team
		else:
			card.sleighers_team = PlayerStatistics.SleighersTeam.NEUTRAL
	print(card.sleighers_team)
	return false

func required_events() -> Array[EventResource]:
	return []
