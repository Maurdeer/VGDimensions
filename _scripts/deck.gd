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

func draw_cards(count : int) -> Array[Card]:
	var drawnCards : Array[Card] = []
	for i in range(count):
		drawnCards.append(deck_array.pop_front())
	update_card_deck_poses()
	return drawnCards

func draw_all_cards() -> Array[Card]:
	return draw_cards(deck_size)

func addCards(cardArray: Array[Card]):
	for card in cardArray:
		addCard(card)

func addCard(card: Card):
	if card in deck_array: return
	if deck_size > 0: 
		remove_child(deck_array[0])
		
	deck_array.push_front(card)
	update_card_deck_poses()
		
	# If Card is attached to a parent previously, then remove it from that parent
	if card.get_parent(): card.get_parent().remove_child(card)
	display_card(card)
		
func add_card_under(card: Card) -> void:
	if card in deck_array: return
	if deck_size == 0: 
		addCard(card)
		return
	deck_array.push_back(card)
	update_card_deck_poses()
	
	if card.get_parent(): card.get_parent().remove_child(card)
		
func get_top_card() -> Card:
	if deck_size <= 0: return null
	return deck_array[0]
	
func get_card_at(idx: int) -> Card:
	if idx >= deck_size or idx < 0: return null
	return deck_array[idx]

func remove_top_card() -> Card:
	if deck_size <= 0: return
	var removed_card = deck_array.pop_front()
	
	remove_child(removed_card)
	removed_card.deck_pos = -1
	update_card_deck_poses()
	
	if deck_size > 0: display_card(deck_array[0])
		
	return removed_card
	
func remove_card_at(idx: int) -> Card:
	if idx >= deck_size: return null
	if idx == 0: return remove_top_card()
	
	var removed_card: Card = deck_array[idx]
	deck_array.remove_at(idx)
	update_card_deck_poses()
	return removed_card

func clear_deck() -> void:
	if deck_size <= 0: return
	remove_child(deck_array[0])
	deck_array.clear()

func shuffleDeck():
	if deck_size <= 0: return
	remove_child(deck_array[0])
	deck_array.shuffle()
	add_child(deck_array[0])
	update_card_deck_poses()

func mergeDeck(merging_deck : Deck):
	if merging_deck.deck_size <= 0: return
	if deck_size > 0: remove_child(deck_array[0])
	deck_array.append_array(merging_deck.deck_array)
	merging_deck.clear_deck()
	
	if deck_size > 0:
		add_child(deck_array[0])
		update_card_deck_poses()
		if flipped: deck_array[0].flip_reveal()
		else: deck_array[0].flip_hide()

func is_empty() -> bool:
	return deck_size == 0
	
func display_card(card: Card) -> void:
	if not card in deck_array: return
	add_child(card)
	#card.card_sm.transition_to_state(CardStateMachine.StateType.IN_DECK)
	if flipped: 
		card.flip_reveal()
	else: 
		card.flip_hide()
		
func undisplay_card(card: Card) -> void:
	if not card in deck_array: return
	remove_child(card)
	
func update_card_deck_poses() -> void:
	for i in deck_array.size():
		deck_array[i].deck_pos = i
