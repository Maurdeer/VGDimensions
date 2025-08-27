extends Node2D
class_name Deck

@export var deckSize: int = 0
@export var flipped: bool = false
@export var draggable: bool = false
var deckArray: Array[Card]

# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("_setup")
	
func _setup() -> void:
	for child in get_children():
		if child is Card:
			addCard(child)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func setSize():
	pass

func getSize() -> int:
	return deckArray.size()

func getDeck():
	return deckArray

func drawCards(count : int):
	var drawnCards = []
	for i in range(count):
		drawnCards.append(deckArray.pop_back())
	return drawnCards

func searchForCard():
	pass
	
func addCards(cardArray: Array[Card]):
	for card in cardArray:
		addCard(card)
	
func addCard(card: Card):
	deckArray.push_back(card)
	if flipped:
		card.flip_hide()
	else:
		card.flip_reveal()
	card.draggable = draggable

func addCardAtLocation(cardArray, location := getSize()):
	# Returns success or failure according to Godot
	return deckArray.insert(cardArray, location)

func removeCard() -> Card:
	return deckArray.pop_back()
	
func burnCard():
	# Take a card from the top of the deck and remove it or
	pass

func shuffleDeck():
	deckArray.shuffle()

func mergeDeck(passedDeck : Deck):
	deckArray.append(passedDeck.getDeck())
