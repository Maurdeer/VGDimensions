extends Node2D
class_name PlayerHand

const hand_limit: int = 5
@export var discard_pile: Deck
@export var draw_pile: Deck
@onready var slots: HBoxContainer = $HBoxContainer/Slots
var empty_card: Card
var slot_queue: Array[Control]

var cards_in_hand: Dictionary[Card, Control] = {}

func _ready() -> void:
	for i in range(hand_limit):
		var slot: Control = Control.new()
		slot.mouse_filter = Control.MOUSE_FILTER_IGNORE
		slot.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		slot.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		slot_queue.append(slot)
	call_deferred("_after_ready")
	
func _after_ready() -> void:
	pass
	
func clear_hand() -> void:
	for card in cards_in_hand.keys():
		discard_card(card)
	
func fill_hand() -> void:
	if draw_pile.deck_size + discard_pile.deck_size < hand_limit: 
		printerr("Too little wack, need more cards in your cumilative deck (5 or more cards)")
		return
	while not slot_queue.is_empty():
		draw_card_to_hand()
		
func draw_card_to_hand() -> void:
	if slot_queue.is_empty(): return
	if draw_pile.is_empty(): reshuffle_draw_pile()
	if draw_pile.is_empty(): 
		printerr("Upon Reshuffling, Draw Pile is still empty!")
		return
	
	# Retrieve the card
	var card: Card = draw_pile.remove_top_card()
	card.flip_reveal()
	card.playable = true
	var on_played = func(): discard_card(card)
	card.played.connect(on_played)
	card.played.connect(func(): card.played.disconnect(on_played))
	
	# Acquire a slot from the slot queue to hold the card
	var slot: Control = slot_queue.pop_back()
	slot.add_child(card)
	slots.add_child(slot)
	cards_in_hand[card] = slot
	
func reshuffle_draw_pile() -> void:
	draw_pile.mergeDeck(discard_pile)
	draw_pile.shuffleDeck()
	
func discard_card(card: Card) -> void:
	if cards_in_hand.has(card): 
		# Handle removal of objects related to card hand
		cards_in_hand[card].remove_child(card)
		slots.remove_child(cards_in_hand[card])
		slot_queue.append(cards_in_hand[card])
		cards_in_hand.erase(card)
	
	# TODO: Replace these with the state system variant of cards
	card.draggable = false
	card.playable = false
	card.interactable = false
	
	discard_pile.addCard(card)
