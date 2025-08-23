extends Node2D
class_name RiftGrid

var riftGrid: Array[Array]

var _riftGridWidth: int
var _riftGridHeight: int

#Add functionality for border cards, a la Bullet spawning locations in Willow

#Create Grid
func drawInitialGrid():
	for i in _riftGridWidth:
		riftGrid[i] = Array([], TYPE_OBJECT, "Deck", null)
		for j in _riftGridHeight:
			riftGrid[i][j] = Deck.new()
			drawCard(i,j)

#GRID INFORMATION
func getGridXDim() -> int:
	return _riftGridWidth

func getGridYDim() -> int:
	return _riftGridHeight

func setGridXDim(newDim: int) -> void:
	_riftGridWidth = newDim

func setGridYDim(newDim: int) -> void:
	_riftGridHeight = newDim

#CARD INFORMATION
func getCardAttribute():
	pass

func getCardPosition():
	pass

#MODIFY AND MOVE CARDS

func drawCard(drawToX: int, drawToY: int) -> void:
	#get card from deck
	var newCard: Card = Card.new()
	#THIS IS CORRECT SINCE GRID IS ROW ORDERED
	placeCard(drawToX, drawToY, newCard)
 
func placeCard(placeAtX: int, placeAtY: int, newCard: Card) -> void:
	#THIS IS CORRECT SINCE GRID IS ROW ORDERED
	riftGrid[placeAtY][placeAtX].addCard(newCard)

func moveCardOff(moveOffX: int, moveOffY: int) -> Card:
	return riftGrid[moveOffY][moveOffX].pop_back()

func discardCard(discardFromX: int, discardFromY: int, targetDeck: Deck):
	targetDeck.addCard(riftGrid[discardFromY][discardFromX].removeCardFromGrid())

func removeCardFromGrid(removeFromX: int, removeFromY: int) -> Card:
	return riftGrid[removeFromY][removeFromX].removeCard()

func mutateCardStat():
	pass

func setCardPosition():
	pass

func swapCards(card1X: int, card1Y: int, card2X: int, card2Y: int):
	var tempCard: Card = riftGrid[card1X][card1Y].removeCard()
	riftGrid[card1X][card1Y].addCard(riftGrid[card2X][card2Y].removeCard())
	riftGrid[card2X][card2Y].addCard(tempCard)

func swapDecks(deck1X: int, deck1Y: int, deck2X: int, deck2Y: int):
	var tempDeck: Deck = riftGrid[deck1X][deck1Y]
	riftGrid[deck1X][deck1Y] = riftGrid[deck2X][deck2Y]
	riftGrid[deck2X][deck2Y] = tempDeck

func shuffleCardBackInDeck(shuffleCard: Card, targetDeck: Deck):
	targetDeck.addCard(shuffleCard)
	targetDeck.shuffleDeck()
	return

func shiftCards(shifterCardX: int, shifterCardY: int, rowNotCol: bool, upNotDown: bool, index: int, amount: int):
	if rowNotCol:
		pass
	else:
		pass

func loopCards(rowNotCol: bool, upNotDown: bool, index: int, amount: int):
	pass

func revolveCards():
	pass

func refreshCard():
	pass

func exchangeCard():
	pass
