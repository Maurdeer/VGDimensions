extends Control
class_name QuestManager

static var Instance: QuestManager
var currentQuest : Card
@export var testingPurposeCard : CardResource

func _ready() -> void:
	# Initialize Singleton
	if Instance: 
		queue_free()
		return
	Instance = self
	

func add_quest(card : Card):
	if (card == null):
		print("Null was passed in!")
		return false
	if (card.resource.type != CardResource.CardType.QUEST):
		print("The given card is not a quest!")
		return false
	currentQuest = card
	add_child(currentQuest)
	currentQuest.card_sm.transition_to_state(CardStateMachine.StateType.IN_QUEST)
	currentQuest.flip_hide()
	print("Quest added succesfully!")
	return true
	
func reveal_quest():
	if (currentQuest == null): 
		print("There is no current quest to reveal!")
		return
	currentQuest.flip_reveal()
	currentQuest.on_enter_tree()

func remove_quest():
	if (currentQuest == null):
		print("There is no current quest to remove!")
		return false
	remove_child(currentQuest)
	currentQuest = null	
	print("Quest removed successfully!")
	return true

# This function is likely deprecated, though I don't want to comment it out in fear
# of the M4 Demo happening today
func update_quest():
	if (currentQuest == null):
		print("There is no quest to call update on!")
		return false
	print("Quest updated successfully!")
	return true
