extends Control
class_name RiftGrid

static var Instance: RiftGrid
@onready var grid_container: GridContainer = $HBoxContainer/GridContainer
const CARD = preload("res://_scenes/card/card.tscn")


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
	newCard.card_sm.transition_to_state(CardStateMachine.StateType.IN_RIFT)

func move_card_off(move_off: Vector2i) -> Card:
	var card: Card = grid[move_off.y][move_off.x].remove_top_card()
	card.grid_pos = Vector2i(-1, -1)
	return card

func discardCard(discard_from: Vector2i, target_deck: Deck):
	target_deck.addCard(grid[discard_from.y][discard_from.x].remove_top_card())
	
func discard_entire_deck(discard_from: Vector2i):
	var deck: Deck = grid[discard_from.y][discard_from.x]
	while not deck.is_empty():
		discardCard(discard_from, _rift_discard_pile)

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
	
func swap_decks(deck_pos_a: Vector2i, deck_pos_b: Vector2i):
	if not is_valid_pos(deck_pos_a) or not is_valid_pos(deck_pos_b):
		printerr("Invalid deck positions to swap")
		return
		
	var temp_deck: Deck = Deck.new()
	var deck_a: Deck = grid[deck_pos_a.y][deck_pos_a.x]
	var deck_b: Deck = grid[deck_pos_b.y][deck_pos_b.x]
	while not deck_a.is_empty():
		temp_deck.addCard(deck_a.remove_top_card())
		
	while not deck_b.is_empty():
		deck_a.add_card_under(deck_b.remove_top_card())
	
	while not temp_deck.is_empty():
		deck_b.addCard(temp_deck.remove_top_card())

func shuffle_card_back_in_deck(shuffleCard: Card, targetDeck: Deck):
	targetDeck.addCard(shuffleCard)
	targetDeck.shuffleDeck()
	return

func shift_decks_horizontally(start_pos: Vector2i, offset: int):
	if start_pos.x > rift_grid_width or start_pos.y > rift_grid_height:
		printerr("(%s, %s) is Out of Rift Grid bounds [%s, %s]" % [start_pos, rift_grid_width, rift_grid_height])
	var row: int = start_pos.y
	for column in range(start_pos.x, rift_grid_width):
		var deck_swap_column = column + offset
		var curr_pos = Vector2i(row, column)
		if deck_swap_column >= rift_grid_width or deck_swap_column < 0:
			discard_entire_deck(curr_pos)
			draw_card(curr_pos)
		else:
			swap_decks(curr_pos, Vector2i(row, deck_swap_column))
	

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
	
func is_valid_pos(pos: Vector2i) -> bool:
	return 0 <= pos.x and pos.x < rift_grid_width \
		and 0 <= pos.y and pos.y < rift_grid_height
