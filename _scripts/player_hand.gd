extends Node2D
class_name PlayerHand

@export var discard_pile: Deck
@export var draw_pile: Deck
@onready var slot_1: Control = $HBoxContainer/Slot1
@onready var slot_2: Control = $HBoxContainer/Slot2
@onready var slot_3: Control = $HBoxContainer/Slot3
@onready var slot_4: Control = $HBoxContainer/Slot4
@onready var slot_5: Control = $HBoxContainer/Slot5

func _ready() -> void:
	call_deferred("_setup")

func _setup() -> void:
	fill_hand()
	
func fill_hand() -> void:
	if draw_pile.getSize() == 0: return
	if slot_1.get_child_count() == 0:
		var card: Card = draw_pile.removeCard()
		card.get_parent().remove_child(card)
		slot_1.add_child(card)
		card.position = Vector2.ZERO
		card.flip_reveal()
	if draw_pile.getSize() == 0: return
	if slot_2.get_child_count() == 0:
		var card: Card = draw_pile.removeCard()
		card.get_parent().remove_child(card)
		slot_2.add_child(card)
		card.position = Vector2.ZERO
		card.flip_reveal()
	if draw_pile.getSize() == 0: return
	if slot_3.get_child_count() == 0:
		var card: Card = draw_pile.removeCard()
		card.get_parent().remove_child(card)
		slot_3.add_child(card)
		card.position = Vector2.ZERO
		card.flip_reveal()
	if draw_pile.getSize() == 0: return
	if slot_4.get_child_count() == 0:
		var card: Card = draw_pile.removeCard()
		card.get_parent().remove_child(card)
		slot_4.add_child(card)
		card.position = Vector2.ZERO
		card.flip_reveal()
	if draw_pile.getSize() == 0: return
	if slot_5.get_child_count() == 0:
		var card: Card = draw_pile.removeCard()
		card.get_parent().remove_child(card)
		slot_5.add_child(card)
		card.position = Vector2.ZERO
		card.flip_reveal()
