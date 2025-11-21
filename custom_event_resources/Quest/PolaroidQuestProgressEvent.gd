extends EventResource
class_name PolaroidQuestProgressEvent

@export var necessaryPolaroidAmount: int
var has_triggered : bool = false

func on_execute() -> bool:
	if GameManager.Instance.is_my_turn():
		if (not has_triggered and PlayerStatistics.from_nava_polaroids >= necessaryPolaroidAmount):
			#PlayerStatistics.dimensions_won += 1
			#print("Have won")
			has_triggered = true
			MultiplayerGameManager.Instance.on_quest_completed()
	return false
	
func required_events() -> Array[EventResource]:
	return []
