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
	call_deferred("_after_ready")
	
func _after_ready() -> void:
	add_quest(await CardManager.create_card(testingPurposeCard, false))

func add_quest(card : Card):
	if (card == null):
		print("Null was passed in!")
		return false
	if (card.resource.type != CardResource.CardType.QUEST):
		print("The given card is not a quest!")
		return false
	currentQuest = card
	add_child(currentQuest)
	currentQuest.card_sm.transition_to_state(CardStateMachine.StateType.UNINTERACTABLE)
	currentQuest.flip_reveal()
	print("Quest added succesfully!")
	return true

func remove_quest():
	if (currentQuest == null):
		print("There is no current quest to remove!")
		return false
	remove_child(currentQuest)
	currentQuest = null	
	print("Quest removed successfully!")
	return true

func update_quest():
	if (currentQuest == null):
		print("There is no quest to call update on!")
		return false
	currentQuest.on_quest_progress()
	print("Quest updated successfully!")
	return true
