extends Node2D
class_name PlayerHand

const hand_limit: int = 5
@export var discard_pile: Deck
@export var draw_pile: Deck
@onready var slots: HBoxContainer = $HBoxContainer/Slots
var empty_card: Card

var cards_in_hand: Array[Card] = []

func _ready() -> void:
	call_deferred("_after_ready")
	
func _after_ready() -> void:
	pass
	
func add_to_discard_pile(card: Card) -> void:
	discard_pile.addCard(card)
	
func fill_hand() -> void:
	if draw_pile.deck_size + discard_pile.deck_size < hand_limit: 
		printerr("Too little wack, need more cards in your cumilative deck (5 or more cards)")
		return
	while cards_in_hand.size() < hand_limit:
		draw_card_to_hand()
		
func draw_card_to_hand() -> void:
	if draw_pile.is_empty(): reshuffle_draw_pile()
	if draw_pile.is_empty(): 
		printerr("Upon Reshuffling, Draw Pile is still empty!")
		return
	var card: Card = draw_pile.remove_top_card()
	card.flip_reveal()
	card.draggable = true
	var slot: Control = Control.new()
	slot.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	slot.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	slot.add_child(card)
	slots.add_child(slot)
	cards_in_hand.append(card)
	
func reshuffle_draw_pile() -> void:
	draw_pile.mergeDeck(discard_pile)
	draw_pile.shuffleDeck()
