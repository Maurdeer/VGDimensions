extends Control
class_name RiftGrid

static var Instance: RiftGrid
@onready var grid_container: Control = $GridContainer

var grid: Array[Array]
var slot_grid: Array[Array]

var rift_grid_width: int = 5
var rift_grid_height: int = 5

var _card_refs: Array[Card]
@onready var _rift_deck: Deck =  $Control2/DrawPile
@onready var _rift_discard_pile: Deck = $Control/DiscardPile
var pre_defined_seed: int

func _ready() -> void:
	# Initialize Singleton
	if Instance: 
		queue_free()
		return
	Instance = self
	process_animations()
	call_deferred("_after_ready")
	
func _after_ready() -> void:
	pass

#Add functionality for border cards, a la Bullet spawning locations in Willow

#Create Grid
func clear_grid() -> void:
	for child in grid_container.get_children():
		child.queue_free()
		
	if grid.is_empty() \
	and _rift_deck.is_empty() \
	and _rift_discard_pile.is_empty() \
	and _card_refs.is_empty(): \
		return
		
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
	rift_grid_width = rift_width
	rift_grid_height = rift_height
	# Establish Rift deck and card refs
	# Assume cards are pre_shuffled
	_card_refs = cards
	for card in cards:
		_rift_deck.addCard(card)
	seed(pre_defined_seed)
	_rift_deck.shuffleDeck()
	
	# Generate the intial setup of the rift
	var seperation: float = 140
	grid_container.position = Vector2(-seperation * (rift_grid_height - 1) * 0.5, -seperation * (rift_grid_height - 1)* 0.5)
	for i in range(rift_grid_height):
		grid.append([])
		slot_grid.append([])
		for j in range(rift_grid_width):
			var deck: Deck = Deck.new()
			deck.flipped = true
			grid[i].append(deck)
			
			# Visual Element
			var slot: RiftGridSlot = RiftGridSlot.new()
			slot_grid[i].append(slot)
			slot.grid_position = Vector2i(j,i)
			slot.add_child(deck)
			deck.position = Vector2.ZERO
			grid_container.add_child(slot)
			slot.set_anchors_preset(PRESET_TOP_LEFT)
			slot.position = Vector2(j * seperation, i * seperation)
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
		seed(pre_defined_seed)
		_rift_deck.shuffleDeck()
	
	if _rift_deck.is_empty():
		# Holy bananza bro, time to double this deck I guess
		_double_rift_deck()
	
	var original_pos = _rift_deck.get_top_card().global_position
	new_card = _rift_deck.remove_top_card()
	new_card.global_position = original_pos
	place_card(draw_to, new_card)
	new_card.on_enter_tree()
	
func draw_card_if_empty(draw_to: Vector2i) -> void:
	if grid[draw_to.y][draw_to.x].is_empty():
		draw_card(draw_to)


func place_card(place_at: Vector2i, new_card: Card) -> void:
	#THIS IS CORRECT SINCE GRID IS ROW ORDERED
	assert(is_valid_pos(place_at), "Cannot place card on position (%s, %s)" % [place_at.x, place_at.y])
	var deck: Deck = grid[place_at.y][place_at.x]
	var card_underneath: Card = deck.get_top_card()
	
	# Ensure it is in the scene before doing anything
	var original_pos = new_card.global_position
	deck.addCard(new_card)
	new_card.card_sm.transition_to_state(CardStateMachine.StateType.IN_RIFT)
	new_card.global_position = original_pos
	new_card.grid_pos = place_at
	# Animation?
	queue_animation(func(): 
		if (deck != null):
			await _vfx_move(new_card, deck.position, 0.2)
			AudioManager.play_sfx("place_card")
	)
	
	if card_underneath: 
		card_underneath.on_stack()
		RiftGrid.Instance.emit_global_event(PassiveEventResource.GlobalEvent.ON_CARD_STACK, card_underneath)
	
func place_card_under(place_at: Vector2i, newCard: Card) -> void:
	assert(is_valid_pos(place_at), "Cannot place card on position (%s, %s)" % [place_at.x, place_at.y])
	grid[place_at.y][place_at.x].add_card_under(newCard)
	newCard.grid_pos = place_at
	newCard.card_sm.transition_to_state(CardStateMachine.StateType.IN_RIFT)

func place_deck_from_rift(place_at: Vector2i, from_deck_pos: Vector2i) -> void:	
	var from_deck: Deck = grid[from_deck_pos.y][from_deck_pos.x] as Deck
	var slot: RiftGridSlot = slot_grid[place_at.y][place_at.x] as RiftGridSlot
	# Update information approriatly
	for card in from_deck.deck_array:
		card.grid_pos = slot.grid_position
	from_deck.reparent(slot)
	grid[place_at.y][place_at.x] = from_deck
	grid[from_deck_pos.y][from_deck_pos.x] = null
	queue_animation(func(): _vfx_move(from_deck, Vector2.ZERO))
	
func place_cards(place_at: Vector2i, cards: Array[Card]) -> void:
	for card in cards:
		place_card(place_at, card)
		
func place_cards_under(place_under: Vector2i, cards: Array[Card]) -> void:
	for card in cards:
		place_card_under(place_under, card)

func discard_card_and_draw(card: Card, draw_when_empty: bool = true) -> void:
	var selected_pos : Vector2i = card.grid_pos
	discard_card(card)
	if draw_when_empty and not grid[selected_pos.y][selected_pos.x].is_empty(): return
	draw_card(selected_pos)
	
func discard_card(card: Card) -> bool:
	assert(is_valid_pos(card.grid_pos), "Cannot discard card from position (%s, %s)" % [card.grid_pos.x, card.grid_pos.y])
	#await card.gridVisualizer.dissolve_shader()
	var stack = grid[card.grid_pos.y][card.grid_pos.x]
	assert(0 <= card.deck_pos and card.deck_pos < stack.deck_size, "Incorrect deck position to discard, Card Problem")
	if not card.resource.discardable:
		# TODO: Do some kind of visual to show card isn't discardable
		return false
	grid[card.grid_pos.y][card.grid_pos.x].remove_card_at(card.deck_pos)
	card.grid_pos = Vector2i(-1, -1)
	
	card.on_discard()
	RiftGrid.Instance.emit_global_event(PassiveEventResource.GlobalEvent.ON_CARD_DISCARD, card)
	
	# TODO: Ensure this discard check behavior is correct
	if card.temporary:
		CardManager.remove_card_by_id(card.card_id)
	elif card.owner_pid < 0: 
		_rift_discard_pile.addCard(card)
		card.card_sm.transition_to_state(CardStateMachine.StateType.UNDEFINED)
	elif multiplayer.has_multiplayer_peer() and multiplayer.get_unique_id() == card.owner_pid:
		PlayerHand.Instance.discard_card(card)
	else:
		remove_child(card)
	return true
	
func move_card_to(move_to: Vector2i, move_from: Vector2i) -> void:
	var card: Card = grid[move_from.y][move_from.x].get_top_card()
	card.on_before_move()
	RiftGrid.Instance.emit_global_event(PassiveEventResource.GlobalEvent.ON_CARD_BEFORE_MOVE, card)
	var temp_global_pos = card.global_position # Hackery for animation
	card = grid[move_from.y][move_from.x].remove_top_card()
	card.global_position = temp_global_pos # Hackery for animation
	#print(card.grid_pos)
	place_card(move_to, card)
	card.on_after_move()
	RiftGrid.Instance.emit_global_event(PassiveEventResource.GlobalEvent.ON_CARD_AFTER_MOVE, card)
	
func move_card_to_under(move_to: Vector2i, move_from: Vector2i) -> void:
	var card: Card = grid[move_from.y][move_from.x].get_top_card()
	print(card.grid_pos)
	card.on_before_move()
	RiftGrid.Instance.emit_global_event(PassiveEventResource.GlobalEvent.ON_CARD_BEFORE_MOVE, card)
	card = grid[move_from.y][move_from.x].remove_top_card()
	#print(card.grid_pos)
	place_card_under(move_to, card)
	card.on_after_move()
	RiftGrid.Instance.emit_global_event(PassiveEventResource.GlobalEvent.ON_CARD_AFTER_MOVE, card)
	
func discard_entire_deck(discard_from: Vector2i):
	var deck: Deck = grid[discard_from.y][discard_from.x]
	while not deck.is_empty():
		discard_card(deck.get_top_card())
	grid[discard_from.y][discard_from.x].queue_free()
	grid[discard_from.y][discard_from.x] = null

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
	seed(pre_defined_seed)
	targetDeck.shuffleDeck()
	
func shuffle_card_back_in_draw_pile(shuffleCard: Card):
	shuffle_card_back_in_deck(shuffleCard, _rift_deck)
	
func shuffle_card_back_in_discard_pile(shuffleCard: Card):
	shuffle_card_back_in_deck(shuffleCard, _rift_discard_pile)

func shift_decks_horizontally(start_pos: Vector2i, offset: int):
	if not is_valid_pos(start_pos):
		printerr("(%s, %s) is Out of Rift Grid bounds [%s, %s]" % [start_pos, rift_grid_width, rift_grid_height]) 
	var shift_spots
	if offset > 0: shift_spots = range(rift_grid_width - 1, start_pos.x - 1, -1)
	elif offset < 0: shift_spots = range(0, start_pos.x + 1)
	else: return
	
	var animations: Array[Callable]
	for x in shift_spots:
		var curr_pos = Vector2i(x, start_pos.y)
		var place_pos = Vector2i(x + offset, start_pos.y)
		if x + offset >= rift_grid_width:
			# dintegrate deck
			discard_entire_deck(Vector2i(x, start_pos.y))
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
	if card.hp == -1:
		return false
	return card.damage(amount)
	
func rotate_card(card_pos: Vector2i, dir: Card.CardDirection) -> void:
	var card: Card = get_top_card(card_pos)
	card.rotate(dir)

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

func get_adjacent_cards(pos: Vector2i) -> Array[Card]:
	var targeted_cards : Array[Card]
	if (is_valid_pos(pos + Vector2i(0, 1))):
		targeted_cards.append(grid[pos.y + 1][pos.x].get_top_card())	
	if (is_valid_pos(pos + Vector2i(0, -1))):
		targeted_cards.append(grid[pos.y - 1][pos.x].get_top_card())	
	if (is_valid_pos(pos + Vector2i(1, 0))):
		targeted_cards.append(grid[pos.y][pos.x + 1].get_top_card())	
	if (is_valid_pos(pos + Vector2i(-1, 0))):
		targeted_cards.append(grid[pos.y][pos.x - 1].get_top_card())	
	return targeted_cards

func get_diagonal_cards(pos: Vector2i) -> Array[Card]:
	var targeted_cards  : Array[Card]
	if (is_valid_pos(pos + Vector2i(1, 1))):
		targeted_cards.append(grid[pos.y + 1][pos.x + 1].get_top_card())	
	if (is_valid_pos(pos + Vector2i(-1, 1))):
		targeted_cards.append(grid[pos.y + 1][pos.x - 1].get_top_card())	
	if (is_valid_pos(pos + Vector2i(1, -1))):
		targeted_cards.append(grid[pos.y - 1][pos.x + 1].get_top_card())	
	if (is_valid_pos(pos + Vector2i(-1, -1))):
		targeted_cards.append(grid[pos.y - 1][pos.x - 1].get_top_card())	
		
	return targeted_cards

func get_edge_cards() -> Array[Card]:
	var edge_cards : Array[Card]
	for i in range(rift_grid_height):
		edge_cards.append(grid[i][0].get_top_card())
		edge_cards.append(grid[i][rift_grid_width - 1].get_top_card())
	for j in range(rift_grid_width - 1):
		edge_cards.append(grid[1][j].get_top_card())
		edge_cards.append(grid[rift_grid_height - 1][0].get_top_card())
			
	return edge_cards

func find_lowest_health() -> Card:
	var found_card : Card = null
	for i in rift_grid_height:
		for j in rift_grid_width:
			var curr_card : Card = grid[i][j].get_top_card()
			if curr_card.hp == -1:
				continue
			if found_card == null:
				found_card = curr_card
				continue
			found_card = compare_lower_health(curr_card, found_card)
	return found_card
#filter.call(card)

func compare_higher_health(card_a: Card, card_b : Card) -> Card:
	return card_a if card_a.hp > card_b.hp else card_b

func compare_lower_health(card_a: Card, card_b : Card) -> Card:
	return card_a if card_a.hp < card_b.hp else card_b
	
	
	
# ============================ VFX ==============================================
# Defintly could have used seperate script but weeeeee

var animation_queue: Array[Callable]

func _vfx_move(node: Node2D, target_position: Vector2, duration: float = 0.2) -> void:
	var speed: float = (target_position - node.position).abs().length() / duration
	while node.position != target_position:
		node.position = node.position.move_toward(target_position, get_process_delta_time() * speed)
		if (get_tree() == null):
			break
		await get_tree().process_frame
		
func queue_animation(animation_func: Callable) -> void:
	animation_queue.append(animation_func)
	
func process_animations() -> void:
	while true:
		if not get_tree():
			break
		if animation_queue.is_empty():
			await get_tree().process_frame
			continue
		await animation_queue.pop_front().call()

#================================================================================
# A way to use lambda functions to filter things
# Take in a lambda call to figure out what to filter by, and then go for it
#====================== Section of iterating over the entire grid =====================
# O(n * m) land bruh, but luckily n and m are small. Max size is n*m = 25 for this game hopefully

# Use this function seldomly, 
# if there are better ways to fill empty slots, then do that instead!
func fill_empty_decks() -> void:
	for y in rift_grid_height:
		for x in rift_grid_width:
			if not grid[y][x] or not grid[y][x] is Deck:
				grid[y][x] = Deck.new()
				slot_grid[y][x].add_child(grid[y][x])
			
			if grid[y][x].is_empty(): 
				draw_card(Vector2i(x, y))
	
func on_start_of_new_turn() -> void:
	for y in rift_grid_height:
		for x in rift_grid_width:
			if not grid[y][x].get_top_card():
				draw_card(Vector2i(x,y))
			for card in grid[y][x].deck_array:
				# If the card blocks global events from invoking underneath it
				card.on_start_of_turn()
				if card.resource.blocking: break
			
	await EventManager.process_event_queue()

func on_end_of_new_turn() -> void:
	for y in rift_grid_height:
		for x in rift_grid_width:
			if not grid[y][x].get_top_card():
				draw_card(Vector2i(x,y))
			for card in grid[y][x].deck_array:
				# If the card blocks global events from invoking underneath it
				card.on_end_of_turn()
				if card.resource.blocking: break
	await EventManager.process_event_queue()
	
# Intentionally sequential to avoid broadcast reordering
func emit_global_event(global_event_type: PassiveEventResource.GlobalEvent, card_invoker: Card = null) -> void:
	if card_invoker:
		EventManager.queue_event_group(QuestManager.Instance.currentQuest.passive_events[global_event_type], \
		card_invoker)
		for y in rift_grid_height:
			for x in rift_grid_width:
				for card in (grid[y][x] as Deck).deck_array:			
					EventManager.queue_event_group(card.passive_events[global_event_type], card_invoker)
					# If the card blocks global events from invoking underneath it
					if card.resource.blocking: break
	else:
		for y in rift_grid_height:
			for x in rift_grid_width:
				for card in (grid[y][x] as Deck).deck_array:
					EventManager.queue_event_group(card.passive_events[global_event_type], card)
					EventManager.queue_event_group(QuestManager.Instance.currentQuest.passive_events[global_event_type], card)
					# If the card blocks global events from invoking underneath it
					if card.resource.blocking: break
	# (Ryan) Commented out to avoid processing mid processor await EventManager.process_event_queue()
	
func _on_state_of_grid_change() -> void:
	for y in rift_grid_height:
		for x in rift_grid_width:
			for card in grid[y][x].deck_array:
				# If the card blocks global events from invoking underneath it
				card.on_state_of_grid_change()
				if card.resource.blocking: break
			
# Only when things get CRAAAAZZZZZYYY
# This should hopefully not happen, unless the deck isn't created that well
func _double_rift_deck() -> void:
	for card_ref in _card_refs:
		var card: Card = card_ref.duplicate() as Card
		_rift_deck.addCard(card) 
		card.card_sm.transition_to_state(CardStateMachine.StateType.UNDEFINED)
	seed(pre_defined_seed)
	_rift_deck.shuffleDeck()
