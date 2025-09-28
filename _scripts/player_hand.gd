extends Node2D
class_name PlayerHand

static var Instance: PlayerHand

const hand_limit: int = 5
@export var discard_pile: Deck
@export var draw_pile: Deck
@onready var slots: HBoxContainer = $HBoxContainer/Slots
var empty_card: Card
var slot_queue: Array[Control]

var cards_in_hand: Dictionary[Card, Control] = {}

func _ready() -> void:
	if Instance: 
		queue_free()
		return
	Instance = self
	
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
	var on_played: Callable
	match(card.resource.type):
		CardResource.CardType.FEATURE:
			on_played = discard_card
		CardResource.CardType.ASSET:
			pass
	card.played.connect(on_played)
	# Acquire a slot from the slot queue to hold the card
	var slot: Control = slot_queue.pop_back()
	slot.add_child(card)
	slots.add_child(slot)
	cards_in_hand[card] = slot
	
func reshuffle_draw_pile() -> void:
	draw_pile.mergeDeck(discard_pile)
	draw_pile.shuffleDeck()
	
func discard_card(card: Card) -> void:
	remove_card_from_hand(card)
	
	# TODO: Replace these with the state system variant of cards
	card.playable = false
	card.interactable = false
	
	discard_pile.addCard(card)
	
func remove_card_from_hand(card: Card) -> void:
	if not cards_in_hand.has(card): return
	if card.played.is_connected(discard_card): card.played.disconnect(discard_card)
	if card.get_parent() == cards_in_hand[card]: cards_in_hand[card].remove_child(card)
	slots.remove_child(cards_in_hand[card])
	slot_queue.append(cards_in_hand[card])
	cards_in_hand.erase(card)
