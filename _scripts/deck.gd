extends Node
class_name Deck

@export var deckSize: int = 0
var deckArray: Array[Card]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func setSize():
	pass
func getSize() -> int:
	return deckSize

func drawCard():
	pass
func searchForCard():
	pass
func addCard(newCard: Card, count := 1):
	pass
func removeCard(removedCard: Card, count := 1) -> Card:
	return deckArray.pop_back()
func burnCard():
	pass
func buryCard():
	pass
func shuffleDeck():
	pass
func mergeDeck():
	pass
