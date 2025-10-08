extends Node2D
class_name Deck

var deck_size: int:
	get:
		return deck_array.size()
@export var flipped: bool = false
@export var draggable: bool = false
var deck_array: Array[Card]
const CARD = preload("uid://c3e8058lwu0a")

func _ready():
	call_deferred("_after_ready")

func _after_ready() -> void:
	pass

func drawCards(count : int):
	var drawnCards = []
	for i in range(count):
		drawnCards.append(deck_array.pop_back())
	return drawnCards

func addCards(cardArray: Array[Card]):
	for card in cardArray:
		addCard(card)

func addCard(card: Card):
	if card in deck_array: return
	if deck_size > 0: 
		remove_child(deck_array[deck_size - 1])
	deck_array.push_back(card)
		
	# If Card is attached to a parent previously, then remove it from that parent
	if card.get_parent(): card.get_parent().remove_child(card)
	display_card(card)
		
func add_card_under(card: Card) -> void:
	if card in deck_array: return
	if deck_size == 0: 
		addCard(card)
		return
	deck_array.push_front(card)
		
func get_top_card() -> Card:
	if deck_size <= 0: return null
	return deck_array[deck_size - 1]

func remove_top_card() -> Card:
	if deck_size <= 0: return
	var removed_card = deck_array.pop_back()
	
	remove_child(removed_card)
	
	if deck_size > 0: display_card(deck_array[deck_size - 1])
		
	return removed_card

func clear_deck() -> void:
	if deck_size <= 0: return
	remove_child(deck_array[deck_size - 1])
	deck_array.clear()

func shuffleDeck():
	if deck_size <= 0: return
	remove_child(deck_array[deck_size - 1])
	deck_array.shuffle()
	add_child(deck_array[deck_size - 1])

func mergeDeck(merging_deck : Deck):
	if merging_deck.deck_size <= 0: return
	if deck_size > 0: remove_child(deck_array[deck_size - 1])
	deck_array.append_array(merging_deck.deck_array)
	merging_deck.clear_deck()
	
	if deck_size > 0:
		add_child(deck_array[deck_size - 1])
		if flipped: deck_array[deck_size - 1].flip_reveal()
		else: deck_array[deck_size - 1].flip_hide()

func is_empty() -> bool:
	return deck_size == 0
	
func display_card(card: Card) -> void:
	if not card in deck_array: return
	add_child(card)
	if flipped: 
		card.flip_reveal()
	else: 
		card.flip_hide()
		
func undisplay_card(card: Card) -> void:
	if not card in deck_array: return
	remove_child(card)
