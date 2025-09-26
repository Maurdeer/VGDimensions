extends Node2D
class_name Deck

var deck_size: int:
	get:
		return deck_array.size()
@export var flipped: bool = false
var deck_array: Array[Card]
var card_dict: Dictionary[String, Array]
const CARD = preload("uid://c3e8058lwu0a")

func _ready():
	call_deferred("_after_ready")

func _after_ready() -> void:
	#empty_card = CARD.instantiate()
	#empty_card.resource = CardResource.new()
	#add_child(empty_card)
	#empty_card.flip_hide()
	pass

func drawCards(count : int):
	var drawnCards = []
	for i in range(count):
		drawnCards.append(deck_array.pop_back())
	return drawnCards

func searchForCard(card_id: String) -> Card:
	if not card_dict.has(card_id) or card_dict[card_id].is_empty(): return null
	return card_dict[card_id][0]

func addCards(cardArray: Array[Card]):
	for card in cardArray:
		addCard(card)

func addCard(card: Card):
	var card_id: String = Card.construct_card_id(card.resource.title, card.resource.game_origin)
	if deck_size > 0: remove_child(deck_array[deck_size - 1])
	deck_array.push_back(card)
	if card_dict.has(card_id): card_dict[card_id].append(card)
	else: card_dict[card_id] = [card]
	add_child(card)
	if flipped: card.flip_reveal()
	else: card.flip_hide()

func remove_top_card() -> Card:
	if deck_size <= 0: return
	remove_child(deck_array[deck_size - 1])
	var removed_card = deck_array.pop_back()
	card_dict[removed_card.card_id].pop_back()
	
	if deck_size > 0: add_child(deck_array[deck_size - 1])
		
	return removed_card

func clear_deck() -> void:
	if deck_size <= 0: return
	remove_child(deck_array[deck_size - 1])
	deck_array.clear()
	card_dict.clear()

func shuffleDeck():
	deck_array.shuffle()

func mergeDeck(merging_deck : Deck):
	if deck_size > 0: remove_child(deck_array[deck_size - 1])
	deck_array.append_array(merging_deck.deck_array)
	merging_deck.clear_deck()
	
	add_child(deck_array[deck_size - 1])
	if flipped: deck_array[deck_size - 1].flip_reveal()
	else: deck_array[deck_size - 1].flip_hide()
	
	# Update card dictionary:
	card_dict.clear()
	for card in deck_array:
		if card_dict.has(card.card_id): card_dict[card.card_id].append(card)
		else: card_dict[card.card_id] = [card]

func is_empty() -> bool:
	return deck_size == 0
	
