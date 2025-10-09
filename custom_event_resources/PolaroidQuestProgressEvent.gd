extends EventResource
class_name PolaroidQuestProgressEvent

@export var necessaryPolaroidAmount: int

func execute(card_ref: Card) -> bool:
	#var card_pos: Vector2i = card_ref.grid_pos
	print("We're in the From Nava Quest! Gonna check if the player has won...")
	if (PlayerStatistics.from_nava_polaroids >= necessaryPolaroidAmount):
		print("The player has won! Amazing!")
		
	return true
