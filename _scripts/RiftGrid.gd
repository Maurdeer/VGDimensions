extends Node2D

var riftGrid: Array[Array]

var _riftGridWidth: int
var _riftGridHeight: int

#Add functionality for border cards, a la Bullet spawning locations in Willow

#Create Grid
func drawInitialGrid():
	for i in _riftGridWidth:
		riftGrid[i] = Array([], TYPE_ARRAY, "Array", null)
		for j in _riftGridHeight:
			riftGrid[i][j] = Array([], TYPE_OBJECT, "Node", null)
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
	var newCard: Card
	#THIS IS CORRECT SINCE GRID IS ROW ORDERED
	placeCard(drawToX, drawToY, newCard)
 
func placeCard(placeAtX: int, placeAtY: int, newCard: Card) -> void:
	#THIS IS CORRECT SINCE GRID IS ROW ORDERED
	riftGrid[placeAtY][placeAtX].push_back(newCard)

func moveCardOff(moveOffX: int, moveOffY: int) -> Card:
	return riftGrid[moveOffY][moveOffX].pop_back()

func discardCard(discardFromX: int, discardFromY: int) -> Card:
	return riftGrid[discardFromY][discardFromX].pop_back()

func removeCard(removeFromX: int, removeFromY: int) -> Card:
	return riftGrid[removeFromY][removeFromX].pop_back()

func mutateCardStat():
	pass

func setCardPosition():
	pass

func swapCards():
	pass

func suffleCardBackInDeck():
	pass

func shiftCards():
	pass

func loopCards():
	pass

func revolveCards():
	pass

func refreshCard():
	pass

func exchangeCard():
	pass
