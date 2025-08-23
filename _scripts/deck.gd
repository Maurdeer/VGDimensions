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
	return deckArray.size()

func drawCards(count : int):
	var drawnCards = []
	for i in range(count):
		drawnCards.append(deckArray.pop_back())
	return drawnCards

func searchForCard():
	pass
	
func addCard(cardArray):
	for card in cardArray:
		deckArray.push_back(card)
		

func addCardAtLocation(cardArray, location := getSize()):
	# Returns success or failure according to Godot
	return deckArray.insert(cardArray, location)

func removeCard(removedCard: Card, count := 1) -> Card:
	return deckArray.pop_back()
	
func burnCard():
	# Take a card from the top of the deck and remove it or
	pass

func shuffleDeck():
	deckArray.shuffle()

func mergeDeck(passingDeck : Deck):
	pass
