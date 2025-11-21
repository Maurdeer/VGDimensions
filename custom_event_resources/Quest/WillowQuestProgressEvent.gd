extends EventResource
class_name WillowQuestProgressEvent

var hostess_boss : CardResource = load("res://cards/Willow/TheHostessBoss.tres")
var has_triggered : bool = false

func on_execute() -> bool:
	if GameManager.Instance.is_my_turn():
		# Could break if the hostess ally is killed? Just add a check
		if (not has_triggered and (m_card_invoker.resource.title == hostess_boss.title)):
			has_triggered = true
			MultiplayerGameManager.Instance.on_quest_completed()
			#print(m_card_invoker.resource.title)
	return false
	
func required_events() -> Array[EventResource]:
	return []
