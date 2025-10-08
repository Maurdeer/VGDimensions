extends Control
class_name RiftGrid

static var Instance: RiftGrid
@onready var grid_container: GridContainer = $HBoxContainer/GridContainer
const CARD = preload("res://_scenes/card/card.tscn")


var grid: Array[Array]

var rift_grid_width: int = 3
var rift_grid_height: int = 3

var _card_refs: Array[Card]
@onready var _rift_deck: Deck =  $HBoxContainer/Control2/DrawPile
@onready var _rift_discard_pile: Deck = $HBoxContainer/Control/DiscardPile

func _ready() -> void:
	# Initialize Singleton
	if Instance: 
		queue_free()
		return
	Instance = self
	call_deferred("_after_ready")
	
func _after_ready() -> void:
	GameManager.Instance.on_start_of_turn.connect(_on_start_of_new_turn)
	GameManager.Instance.on_end_of_turn.connect(_on_end_of_new_turn)

#Add functionality for border cards, a la Bullet spawning locations in Willow

#Create Grid
func clear_grid() -> void:
	if grid.is_empty() \
	and _rift_deck.is_empty() \
	and _rift_discard_pile.is_empty() \
	and _card_refs.is_empty(): \
		return
		
	for child in grid_container.get_children():
		child.queue_free()
	grid.clear()
	_rift_deck.clear_deck()
	_rift_discard_pile.clear_deck()
	_card_refs.clear()
	
func generate_new_grid(cards: Array[Card], rift_width: int, rift_height: int) -> void:
	# Check validatity of parameters
	if cards.is_empty(): 
		printerr("You cannot generate the rift with an empty list of cards!")
		return
	if rift_height < 1 or rift_height > 5 or rift_width < 1 or rift_width > 5:
		printerr("Invalid rift width and height settings")
		return
		
	# Clean up rift if was prior in use
	clear_grid()
	
	# Establish Rift deck and card refs
	_card_refs = cards
	for card in cards:
		_rift_deck.addCard(card)
	_rift_deck.shuffleDeck()
	
	# Generate the intial setup of the rift
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
	if _rift_deck.is_empty():
		# Must have cards in discard pile to shuffle in
		_rift_deck.mergeDeck(_rift_discard_pile)
		_rift_deck.shuffleDeck()
	
	if _rift_deck.is_empty():
		# Holy bananza bro, time to double this deck I guess
		_double_rift_deck()
		
	new_card = _rift_deck.remove_top_card()
		
	#THIS IS CORRECT SINCE GRID IS ROW ORDERED
	place_card(draw_to, new_card)
 
func place_card(place_at: Vector2i, newCard: Card) -> void:
	#THIS IS CORRECT SINCE GRID IS ROW ORDERED
	assert(is_valid_pos(place_at), "Cannot place card on position (%s, %s)" % [place_at.x, place_at.y])
	var card_underneath: Card = grid[place_at.y][place_at.x].get_top_card()
	# TODO: THIS IS NOT RIGHT, PUT ON BOTTOM
	# THEN SUPPORT VECTOR3i, to interface with internal card deck positions
	# Only done for M2 to support stacking on buttons rn
	if card_underneath: await card_underneath.on_stack()
	grid[place_at.y][place_at.x].addCard(newCard)
	newCard.grid_pos = place_at
	newCard.card_sm.transition_to_state(CardStateMachine.StateType.IN_RIFT)
	
	
func place_card_under(place_at: Vector2i, newCard: Card) -> void:
	assert(is_valid_pos(place_at), "Cannot place card on position (%s, %s)" % [place_at.x, place_at.y])
	grid[place_at.y][place_at.x].add_card_under(newCard)
	newCard.grid_pos = place_at
	newCard.card_sm.transition_to_state(CardStateMachine.StateType.IN_RIFT)

func place_deck_from_rift(place_at: Vector2i, from_deck_pos: Vector2i) -> void:
	var deck: Deck = grid[from_deck_pos.y][from_deck_pos.x];
	while not deck.is_empty():
		move_card_to_under(place_at, from_deck_pos)
	
func place_cards(place_at: Vector2i, cards: Array[Card]) -> void:
	for card in cards:
		place_card(place_at, card)
		
func place_cards_under(place_under: Vector2i, cards: Array[Card]) -> void:
	for card in cards:
		place_card_under(place_under, card)

func discard_card_and_draw(discard_from: Vector2i, draw_when_empty: bool = true) -> void:
	discard_card(discard_from)
	if draw_when_empty and not grid[discard_from.y][discard_from.x].is_empty(): return
	draw_card(discard_from)
	
func discard_card(discard_from: Vector2i) -> void:
	assert(is_valid_pos(discard_from), "Cannot discard card from position (%s, %s)" % [discard_from.x, discard_from.y])
	var card: Card = grid[discard_from.y][discard_from.x].remove_top_card()
	card.grid_pos = Vector2i(-1, -1)
	
	# (Ryan) When we add netcoding, do a more explicit player check in the networked version
	if card.player_owner == "": 
		_rift_discard_pile.addCard(card)
		card.card_sm.transition_to_state(CardStateMachine.StateType.UNDEFINED)
	else:
		PlayerHand.Instance.discard_card(card)
	
	await card.on_discard()
	
func move_card_to(move_to: Vector2i, move_from: Vector2i) -> void:
	var card: Card = grid[move_from.y][move_from.x].remove_top_card()
	await card.on_before_move()
	place_card(move_to, card)
	await card.on_after_move()
	
func move_card_to_under(move_to: Vector2i, move_from: Vector2i) -> void:
	var card: Card = grid[move_from.y][move_from.x].remove_top_card()
	place_card_under(move_to, card)
	
func discard_entire_deck(discard_from: Vector2i):
	var deck: Deck = grid[discard_from.y][discard_from.x]
	while not deck.is_empty():
		discard_card(discard_from)

func removeCardFromGrid(remove_from: Vector2i) -> Card:
	return grid[remove_from.y][remove_from.x].removeCard()

func mutateCardStat():
	pass

func setCardPosition():
	pass

func swap_cards(card_a_pos: Vector2i, card_b_pos: Vector2i):
	var card_a: Card =  grid[card_a_pos.y][card_a_pos.x].remove_top_card()
	move_card_to(card_a_pos, card_b_pos)
	place_card(card_b_pos, card_a)
	
func swap_decks(deck_pos_a: Vector2i, deck_pos_b: Vector2i):
	if not is_valid_pos(deck_pos_a) or not is_valid_pos(deck_pos_b):
		printerr("Invalid deck positions to swap")
		return
		
	var temp_deck: Deck = Deck.new()
	var deck_a: Deck = grid[deck_pos_a.y][deck_pos_a.x]
	var deck_b: Deck = grid[deck_pos_b.y][deck_pos_b.x]
	while not deck_a.is_empty():
		var card_a: Card = grid[deck_pos_a.y][deck_pos_a.x].remove_top_card()
		temp_deck.addCard(card_a)
		
	while not deck_b.is_empty():
		move_card_to_under(deck_pos_a, deck_pos_b)
	
	while not temp_deck.is_empty():
		place_card(deck_pos_b, temp_deck.remove_top_card())

func shuffle_card_back_in_deck(shuffleCard: Card, targetDeck: Deck):
	shuffleCard.card_sm.transition_to_state(CardStateMachine.StateType.UNDEFINED)
	targetDeck.addCard(shuffleCard)
	targetDeck.shuffleDeck()

func shift_decks_horizontally(start_pos: Vector2i, offset: int):
	if not is_valid_pos(start_pos):
		printerr("(%s, %s) is Out of Rift Grid bounds [%s, %s]" % [start_pos, rift_grid_width, rift_grid_height]) 
	var shift_spots
	if offset > 0: shift_spots = range(rift_grid_width - 1, start_pos.x - 1, -1)
	elif offset < 0: shift_spots = range(0, start_pos.x + 1)
	else: return
	
	for x in shift_spots:
		var curr_pos = Vector2i(x, start_pos.y)
		var place_pos = Vector2i(x + offset, start_pos.y)
		if place_pos.x >= rift_grid_width:
			discard_entire_deck(curr_pos)
		else:
			place_deck_from_rift(place_pos, curr_pos)
		
	fill_empty_decks()

func shift_decks_vertically(start_pos: Vector2i, offset: int):
	if not is_valid_pos(start_pos):
		printerr("(%s, %s) is Out of Rift Grid bounds [%s, %s]" % [start_pos, rift_grid_width, rift_grid_height]) 
	var shift_spots
	if offset > 0: shift_spots = range(rift_grid_height - 1, start_pos.y - 1, -1)
	elif offset < 0: shift_spots = range(0, start_pos.y + 1)
	else: return
	
	for y in shift_spots:
		var curr_pos = Vector2i(start_pos.x, y)
		var place_pos = Vector2i(start_pos.x, y + offset)
		if place_pos.y >= rift_grid_height:
			discard_entire_deck(curr_pos)
		else:
			place_deck_from_rift(place_pos, curr_pos)
		
	fill_empty_decks()
	
func loop_cards_horizontally(startY: int, leftNotRight: bool, amount: int):
	if leftNotRight:
		while amount > 0:
			var tempDeck: Deck = grid[startY].pop_front()
			grid[startY].push_back(tempDeck)
	else:
		while amount > 0:
			var tempDeck: Deck = grid[startY].pop_back()
			grid[startY].push_front(tempDeck)

func loop_cards_vertically(startX: int, upNotDown: bool, amount: int):
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
			
# Returns whether or not the card was discarded
func damage_card(card_pos: Vector2i, amount: int) -> bool:
	var card: Card = get_top_card(card_pos)
	if card.damage(amount):
		await discard_card(card_pos)
		return true
	return false

func revolveCards():
	pass

func refreshCard():
	pass

func exchangeCard():
	pass
	
func is_valid_pos(pos: Vector2i) -> bool:
	return 0 <= pos.x and pos.x < rift_grid_width \
		and 0 <= pos.y and pos.y < rift_grid_height
			
func get_top_card(pos: Vector2i) -> Card:
	assert(is_valid_pos(pos), "Incorrect position: (%s, %s)" % [pos.x, pos.y]) 
	return grid[pos.y][pos.x].get_top_card()
	
#====================== Section of iterating over the entire grid =====================
# O(n * m) land bruh, but luckily n and m are small. Max size is n*m = 25 for this game hopefully

# Use this function seldomly, 
# if there are better ways to fill empty slots, then do that instead!
func fill_empty_decks() -> void:
	for y in rift_grid_height:
		for x in rift_grid_width:
			if grid[y][x].is_empty(): draw_card(Vector2i(x, y))
	
func _on_start_of_new_turn() -> void:
	for y in rift_grid_height:
		for x in rift_grid_width:
			await grid[y][x].get_top_card().on_start_of_turn()

func _on_end_of_new_turn() -> void:
	for y in rift_grid_height:
		for x in rift_grid_width:
			await grid[y][x].get_top_card().on_end_of_turn()
			
func _on_state_of_grid_change() -> void:
	for y in rift_grid_height:
		for x in rift_grid_width:
			await grid[y][x].get_top_card().on_state_of_grid_change()
			
# Only when things get CRAAAAZZZZZYYY
# This should hopefully not happen, unless the deck isn't created that well
func _double_rift_deck() -> void:
	for card_ref in _card_refs:
		var card: Card = card_ref.duplicate() as Card
		_rift_deck.addCard(card) 
		card.card_sm.transition_to_state(CardStateMachine.StateType.UNDEFINED)
	_rift_deck.shuffleDeck()
