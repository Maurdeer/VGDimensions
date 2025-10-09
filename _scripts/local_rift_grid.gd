extends RiftGrid
class_name LocalRiftGrid

func _ready() -> void:
	pass

func _after_ready() -> void:
	pass
	
# Assume Preshuffled for networked version	
func generate_new_grid_2(cards: Array[Card], rift_width: int, rift_height: int, seed: int) -> void:
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
	# Assume cards are pre_shuffled
	_card_refs = cards
	for card in cards:
		_rift_deck.addCard(card)
	seed(seed)
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
			
			draw_card_2(Vector2i(j,i), seed)

func draw_card_2(draw_to: Vector2i, seed: int) -> void:
	#get card from deck
	var new_card: Card
	if _rift_deck.is_empty():
		# Must have cards in discard pile to shuffle in
		_rift_deck.mergeDeck(_rift_discard_pile)
		seed(seed)
		_rift_deck.shuffleDeck()
	
	if _rift_deck.is_empty():
		# Holy bananza bro, time to double this deck I guess
		_double_rift_deck()
		
	new_card = _rift_deck.remove_top_card()
		
	#THIS IS CORRECT SINCE GRID IS ROW ORDERED
	place_card(draw_to, new_card)
