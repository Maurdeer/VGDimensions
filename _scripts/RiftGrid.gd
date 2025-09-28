extends Control
class_name RiftGrid

static var Instance: RiftGrid
@onready var grid_container: GridContainer = $GridContainer
const CARD = preload("uid://c3e8058lwu0a")

var riftGrid: Array[Array]

var _riftGridWidth: int = 3
var _riftGridHeight: int = 3

func _ready() -> void:
	# Initialize Singleton
	if Instance: 
		queue_free()
		return
	Instance = self

#Add functionality for border cards, a la Bullet spawning locations in Willow

#Create Grid
func drawInitialGrid():
	grid_container.columns = _riftGridWidth
	for i in range(_riftGridHeight):
		riftGrid.append([])
		for j in range(_riftGridWidth):
			var deck: Deck = Deck.new()
			deck.flipped = true
			riftGrid[i].append(deck)
			
			# Visual Element
			var slot: RiftGridSlot = RiftGridSlot.new()
			slot.grid_position = Vector2i(j,i)
			slot.add_child(riftGrid[i][j])
			grid_container.add_child(slot)
			
			drawCard(Vector2i(j,i))

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

func drawCard(draw_to: Vector2i) -> void:
	#get card from deck
	var newCard: Card = CARD.instantiate()
	#THIS IS CORRECT SINCE GRID IS ROW ORDERED
	placeCard(draw_to, newCard)
 
func placeCard(place_at: Vector2i, newCard: Card) -> void:
	#THIS IS CORRECT SINCE GRID IS ROW ORDERED
	newCard.grid_pos = place_at
	riftGrid[place_at.y][place_at.x].addCard(newCard)

func moveCardOff(move_off: Vector2i) -> Card:
	return riftGrid[move_off.y][move_off.x].pop_back()

func discardCard(discard_from: Vector2i, target_deck: Deck):
	target_deck.addCard(riftGrid[discard_from.y][discard_from.x].removeCardFromGrid())

func removeCardFromGrid(remove_from: Vector2i) -> Card:
	return riftGrid[remove_from.y][remove_from.x].removeCard()

func mutateCardStat():
	pass

func setCardPosition():
	pass

func swapCards(card_a: Vector2i, card_b: Vector2i):
	var tempCard: Card = riftGrid[card_a.y][card_a.x].removeCard()
	riftGrid[card_a.y][card_a.x].addCard(riftGrid[card_b.y][card_b.x].removeCard())
	riftGrid[card_b.y][card_b.x].addCard(tempCard)

func swapDecks(deck_a: Vector2i, deck_b: Vector2i):
	var tempDeck: Deck = riftGrid[deck_a.y][deck_a.x]
	riftGrid[deck_a.x][deck_a.y] = riftGrid[deck_b.y][deck_b.x]
	riftGrid[deck_b.y][deck_b.x] = tempDeck

func shuffleCardBackInDeck(shuffleCard: Card, targetDeck: Deck):
	targetDeck.addCard(shuffleCard)
	targetDeck.shuffleDeck()
	return

func shiftCardsHorizontal(start_pos: Vector2i, leftNotRight: bool, amount: int):
	var discardPile: Deck = Deck.new()
	if leftNotRight:
		while amount > 0:
			var i: int = start_pos.x
			var tempDeck: Deck = Deck.new()
			var tempDeck2: Deck = Deck.new()
			while i >= 0:
				if i - 1 >= 0:
					tempDeck = riftGrid[start_pos.y][i - 1]
					riftGrid[start_pos.y][i - 1] = riftGrid[start_pos.y][i]
					riftGrid[start_pos.y][i] = tempDeck2
					tempDeck2 = tempDeck
				else:
					for deadCard in riftGrid[start_pos.y][i].size():
						discardCard(Vector2i(i, start_pos.y), discardPile)
					riftGrid[start_pos.y][i] = tempDeck2
				i -= 1
			drawCard(start_pos)
			amount -= 1
	else:
		while amount > 0:
			var i: int = start_pos.y
			var tempDeck: Deck = Deck.new()
			var tempDeck2: Deck = Deck.new()
			while i < _riftGridWidth:
				if i + 1 < _riftGridWidth:
					tempDeck = riftGrid[start_pos.y][i + 1]
					riftGrid[start_pos.y][i + 1] = riftGrid[start_pos.y][i]
					riftGrid[start_pos.y][i] = tempDeck2
					tempDeck2 = tempDeck
				else:
					for deadCard in riftGrid[start_pos.y][i].size():
						discardCard(Vector2i(i, start_pos.y), discardPile)
					riftGrid[start_pos.y][i] = tempDeck2
				i += 1
			drawCard(start_pos)
			amount -= 1

func shiftCardsVertical(start_pos: Vector2i, upNotDown: bool, amount: int):
	var discardPile: Deck = Deck.new()
	if upNotDown:
		while amount > 0:
			var i: int = start_pos.y
			var tempDeck: Deck = Deck.new()
			var tempDeck2: Deck = Deck.new()
			while i >= 0:
				if i - 1 >= 0:
					tempDeck = riftGrid[i - 1][start_pos.x]
					riftGrid[i - 1][start_pos.x] = riftGrid[i][start_pos.x]
					riftGrid[i][start_pos.x] = tempDeck2
					tempDeck2 = tempDeck
				else:
					for deadCard in riftGrid[i][start_pos.x].size():
						discardCard(Vector2i(start_pos.x, i), discardPile)
					riftGrid[i][start_pos.x] = tempDeck2
				i -= 1
			drawCard(start_pos)
			amount -= 1
	else:
		while amount > 0:
			var i: int = start_pos.y
			var tempDeck: Deck = Deck.new()
			var tempDeck2: Deck = Deck.new()
			while i < _riftGridHeight:
				if i + 1 < _riftGridHeight:
					tempDeck = riftGrid[i + 1][start_pos.x]
					riftGrid[i + 1][start_pos.x] = riftGrid[i][start_pos.x]
					riftGrid[i][start_pos.x] = tempDeck2
					tempDeck2 = tempDeck
				else:
					for deadCard in riftGrid[i][start_pos.x].size():
						discardCard(Vector2(start_pos.x, i), discardPile)
					riftGrid[i][start_pos.x] = tempDeck2
				i += 1
			drawCard(start_pos)
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
