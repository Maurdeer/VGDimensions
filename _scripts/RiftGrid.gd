extends Node2D
class_name RiftGrid

var riftGrid: Array[Array]

var _riftGridWidth: int
var _riftGridHeight: int

#Add functionality for border cards, a la Bullet spawning locations in Willow

#Create Grid
func drawInitialGrid():
	for i in _riftGridHeight:
		riftGrid[i] = Array([], TYPE_OBJECT, "Deck", null)
		for j in _riftGridWidth:
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
	var tempCard: Card = riftGrid[card1Y][card1X].removeCard()
	riftGrid[card1Y][card1X].addCard(riftGrid[card2Y][card2X].removeCard())
	riftGrid[card2Y][card2X].addCard(tempCard)

func swapDecks(deck1X: int, deck1Y: int, deck2X: int, deck2Y: int):
	var tempDeck: Deck = riftGrid[deck1Y][deck1X]
	riftGrid[deck1X][deck1Y] = riftGrid[deck2Y][deck2X]
	riftGrid[deck2Y][deck2X] = tempDeck

func shuffleCardBackInDeck(shuffleCard: Card, targetDeck: Deck):
	targetDeck.addCard(shuffleCard)
	targetDeck.shuffleDeck()
	return

func shiftCardsHorizontal(startX: int, startY: int, leftNotRight: bool, amount: int):
	var discardPile: Deck = Deck.new()
	if leftNotRight:
		while amount > 0:
			var i: int = startX
			var tempDeck: Deck = Deck.new()
			var tempDeck2: Deck = Deck.new()
			while i >= 0:
				if i - 1 >= 0:
					tempDeck = riftGrid[startY][i - 1]
					riftGrid[startY][i - 1] = riftGrid[startY][i]
					riftGrid[startY][i] = tempDeck2
					tempDeck2 = tempDeck
				else:
					for deadCard in riftGrid[startY][i].size():
						discardCard(i, startY, discardPile)
					riftGrid[startY][i] = tempDeck2
				i -= 1
			drawCard(startX, startY)
			amount -= 1
	else:
		while amount > 0:
			var i: int = startY
			var tempDeck: Deck = Deck.new()
			var tempDeck2: Deck = Deck.new()
			while i < _riftGridWidth:
				if i + 1 < _riftGridWidth:
					tempDeck = riftGrid[startY][i + 1]
					riftGrid[startY][i + 1] = riftGrid[startY][i]
					riftGrid[startY][i] = tempDeck2
					tempDeck2 = tempDeck
				else:
					for deadCard in riftGrid[startY][i].size():
						discardCard(i, startY, discardPile)
					riftGrid[startY][i] = tempDeck2
				i += 1
			drawCard(startX, startY)
			amount -= 1

func shiftCardsVertical(startX: int, startY: int, upNotDown: bool, amount: int):
	var discardPile: Deck = Deck.new()
	if upNotDown:
		while amount > 0:
			var i: int = startY
			var tempDeck: Deck = Deck.new()
			var tempDeck2: Deck = Deck.new()
			while i >= 0:
				if i - 1 >= 0:
					tempDeck = riftGrid[i - 1][startX]
					riftGrid[i - 1][startX] = riftGrid[i][startX]
					riftGrid[i][startX] = tempDeck2
					tempDeck2 = tempDeck
				else:
					for deadCard in riftGrid[i][startX].size():
						discardCard(startX, i, discardPile)
					riftGrid[i][startX] = tempDeck2
				i -= 1
			drawCard(startX, startY)
			amount -= 1
	else:
		while amount > 0:
			var i: int = startY
			var tempDeck: Deck = Deck.new()
			var tempDeck2: Deck = Deck.new()
			while i < _riftGridHeight:
				if i + 1 < _riftGridHeight:
					tempDeck = riftGrid[i + 1][startX]
					riftGrid[i + 1][startX] = riftGrid[i][startX]
					riftGrid[i][startX] = tempDeck2
					tempDeck2 = tempDeck
				else:
					for deadCard in riftGrid[i][startX].size():
						discardCard(startX, i, discardPile)
					riftGrid[i][startX] = tempDeck2
				i += 1
			drawCard(startX, startY)
			amount -= 1

func loopCardsHorizontal(startY: int, leftNotRight: bool, amount: int):
	if leftNotRight:
		while amount > 0:
			var tempDeck: Deck = riftGrid[startY].pop_front()
			riftGrid[startY].push_back(tempDeck)
	else:
		while amount > 0:
			var tempDeck: Deck = riftGrid[startY].pop_back()
			riftGrid[startY].push_front(tempDeck)

func loopCardsVertical(startX: int, upNotDown: bool, amount: int):
	if upNotDown:
		while amount > 0:
			var tempDeck: Deck = riftGrid[0][startX]
			var i: int = 1
			while i < _riftGridHeight:
				riftGrid[i - 1][startX] = riftGrid[i][startX]
				i += 1
			riftGrid[_riftGridHeight - 1][startX] = tempDeck
	else:
		while amount > 0:
			var tempDeck: Deck = riftGrid[_riftGridHeight - 1][startX]
			var i: int = _riftGridHeight - 2
			while i >= 0:
				riftGrid[i + 1][startX] = riftGrid[i][startX]
				i -= 1
			riftGrid[0][startX] = tempDeck

func revolveCards():
	pass

func refreshCard():
	pass

func exchangeCard():
	pass
