extends Control
class_name RiftGrid

static var Instance: RiftGrid
@onready var grid_container: GridContainer = $HBoxContainer/GridContainer
const CARD = preload("uid://c3e8058lwu0a")

var grid: Array[Array]

var rift_grid_width: int = 3
var rift_grid_height: int = 3

var rift_card_pack: CardPackResource:
	set(value):
		rift_card_pack = value
		if not rift_card_pack: return
		for card_res in rift_card_pack.card_resources.keys():
			for i in rift_card_pack.card_resources[card_res]:
				var card: Card = CARD.instantiate()
				card.resource = card_res
				_card_refs.append(card)
var _card_refs: Array[Card]
@onready var _rift_deck: Deck =  $HBoxContainer/Control2/DrawPile
@onready var _rift_discard_pile: Deck = $HBoxContainer/Control/DiscardPile

func _ready() -> void:
	# Initialize Singleton
	if Instance: 
		queue_free()
		return
	Instance = self

#Add functionality for border cards, a la Bullet spawning locations in Willow

#Create Grid
func clear_grid() -> void:
	for child in grid_container.get_children():
		child.queue_free()
	grid.clear()
	_rift_deck.clear_deck()
	_rift_discard_pile.clear_deck()

func draw_initial_grid():
	if not grid.is_empty() or not _rift_deck.is_empty(): clear_grid()
	for card in _card_refs:
		_rift_deck.addCard(card)
	_rift_deck.shuffleDeck()
	grid_container.columns = rift_grid_width
	for i in range(rift_grid_height):
		grid.append([])
		for j in range(rift_grid_width):
			var deck: Deck = Deck.new()
			deck.flipped = true
			grid[i].append(deck)
			
			# Visual Element
			var slot: RiftGridSlot = RiftGridSlot.new()
			slot.grid_position = Vector2i(j,i)
			slot.add_child(grid[i][j])
			grid_container.add_child(slot)
			
			draw_card(Vector2i(j,i))

#CARD INFORMATION
func getCardAttribute():
	pass

func getCardPosition():
	pass

#MODIFY AND MOVE CARDS

func draw_card(draw_to: Vector2i) -> void:
	#get card from deck
	var new_card: Card
	if not _rift_deck.is_empty():
		new_card = _rift_deck.remove_top_card()
	else:
		new_card = CARD.instantiate()
	#THIS IS CORRECT SINCE GRID IS ROW ORDERED
	place_card(draw_to, new_card)
 
func place_card(place_at: Vector2i, newCard: Card) -> void:
	#THIS IS CORRECT SINCE GRID IS ROW ORDERED
	grid[place_at.y][place_at.x].addCard(newCard)
	newCard.grid_pos = place_at
<<<<<<< HEAD
<<<<<<< HEAD
	newCard.card_sm.transition_to_state(CardStateMachine.StateType.IN_RIFT)
=======
	newCard.card_sm.transition_to_state(CardStateMachine.StateType.ON_RIFT)
>>>>>>> 7cfb420 (ryan's wacky world of gridvisualizers)
=======
	newCard.card_sm.transition_to_state(CardStateMachine.StateType.IN_RIFT)
>>>>>>> 2820326 (My Changes)

func move_card_off(move_off: Vector2i) -> Card:
	var card: Card = grid[move_off.y][move_off.x].remove_top_card()
	card.grid_pos = Vector2i(-1, -1)
	return card

func discardCard(discard_from: Vector2i, target_deck: Deck):
	target_deck.addCard(grid[discard_from.y][discard_from.x].remove_top_card())

func removeCardFromGrid(remove_from: Vector2i) -> Card:
	return grid[remove_from.y][remove_from.x].removeCard()

func mutateCardStat():
	pass

func setCardPosition():
	pass

func swap_cards(card_a_pos: Vector2i, card_b_pos: Vector2i):
	var card_a: Card =  move_card_off(card_a_pos)
	place_card(card_a_pos, move_card_off(card_b_pos))
	place_card(card_b_pos, card_a)
	
func swapDecks(deck_a: Vector2i, deck_b: Vector2i):
	var tempDeck: Deck = grid[deck_a.y][deck_a.x]
	grid[deck_a.x][deck_a.y] = grid[deck_b.y][deck_b.x]
	grid[deck_b.y][deck_b.x] = tempDeck

func shuffleCardBackInDeck(shuffleCard: Card, targetDeck: Deck):
	targetDeck.addCard(shuffleCard)
	targetDeck.shuffleDeck()
	return

func shift_decks_horizontally(start_pos: Vector2i, leftNotRight: bool, amount: int):
	if leftNotRight:
		while amount > 0:
			var i: int = start_pos.x
			var tempDeck: Deck = Deck.new()
			var tempDeck2: Deck = Deck.new()
			while i >= 0:
				if i - 1 >= 0:
					tempDeck = grid[start_pos.y][i - 1]
					grid[start_pos.y][i - 1] = grid[start_pos.y][i]
					grid[start_pos.y][i] = tempDeck2
					tempDeck2 = tempDeck
				else:
					for deadCard in grid[start_pos.y][i].deck_size:
						discardCard(Vector2i(i, start_pos.y), _rift_discard_pile)
					grid[start_pos.y][i] = tempDeck2
				i -= 1
			draw_card(start_pos)
			amount -= 1
	else:
		while amount > 0:
			var i: int = start_pos.y
			var tempDeck: Deck = Deck.new()
			var tempDeck2: Deck = Deck.new()
			while i < rift_grid_width:
				if i + 1 < rift_grid_width:
					tempDeck = grid[start_pos.y][i + 1]
					grid[start_pos.y][i + 1] = grid[start_pos.y][i]
					grid[start_pos.y][i] = tempDeck2
					tempDeck2 = tempDeck
				else:
					for deadCard in grid[start_pos.y][i].deck_size:
						discardCard(Vector2i(i, start_pos.y), _rift_discard_pile)
					grid[start_pos.y][i] = tempDeck2
				i += 1
			draw_card(start_pos)
			amount -= 1

func shiftCardsVertical(start_pos: Vector2i, upNotDown: bool, amount: int):
	if upNotDown:
		while amount > 0:
			var i: int = start_pos.y
			var tempDeck: Deck = Deck.new()
			var tempDeck2: Deck = Deck.new()
			while i >= 0:
				if i - 1 >= 0:
					tempDeck = grid[i - 1][start_pos.x]
					grid[i - 1][start_pos.x] = grid[i][start_pos.x]
					grid[i][start_pos.x] = tempDeck2
					tempDeck2 = tempDeck
				else:
					for deadCard in grid[i][start_pos.x].deck_size:
						discardCard(Vector2i(start_pos.x, i), _rift_discard_pile)
					grid[i][start_pos.x] = tempDeck2
				i -= 1
			draw_card(start_pos)
			amount -= 1
	else:
		while amount > 0:
			var i: int = start_pos.y
			var tempDeck: Deck = Deck.new()
			var tempDeck2: Deck = Deck.new()
			while i < rift_grid_height:
				if i + 1 < rift_grid_height:
					tempDeck = grid[i + 1][start_pos.x]
					grid[i + 1][start_pos.x] = grid[i][start_pos.x]
					grid[i][start_pos.x] = tempDeck2
					tempDeck2 = tempDeck
				else:
					for deadCard in grid[i][start_pos.x].deck_size:
						discardCard(Vector2(start_pos.x, i), _rift_discard_pile)
					grid[i][start_pos.x] = tempDeck2
				i += 1
			draw_card(start_pos)
			amount -= 1

func loopCardsHorizontal(startY: int, leftNotRight: bool, amount: int):
	if leftNotRight:
		while amount > 0:
			var tempDeck: Deck = grid[startY].pop_front()
			grid[startY].push_back(tempDeck)
	else:
		while amount > 0:
			var tempDeck: Deck = grid[startY].pop_back()
			grid[startY].push_front(tempDeck)

func loopCardsVertical(startX: int, upNotDown: bool, amount: int):
	if upNotDown:
		while amount > 0:
			var tempDeck: Deck = grid[0][startX]
			var i: int = 1
			while i < rift_grid_height:
				grid[i - 1][startX] = grid[i][startX]
				i += 1
			grid[rift_grid_height - 1][startX] = tempDeck
	else:
		while amount > 0:
			var tempDeck: Deck = grid[rift_grid_height - 1][startX]
			var i: int = rift_grid_height - 2
			while i >= 0:
				grid[i + 1][startX] = grid[i][startX]
				i -= 1
			grid[0][startX] = tempDeck

func revolveCards():
	pass

func refreshCard():
	pass

func exchangeCard():
	pass
