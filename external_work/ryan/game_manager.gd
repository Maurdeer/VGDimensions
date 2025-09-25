extends Node
class_name GameManager

@export var cards: Array[CardResource]

@onready var player_hand: PlayerHand = $player_hand
const CARD = preload("uid://c3e8058lwu0a")


func _ready() -> void:
	call_deferred("_after_ready")

func _after_ready() -> void:
	create_cards_for_player_hand()
	
func create_cards_for_player_hand():
	for card_res in cards:
		var card: Card = CARD.instantiate()
		card.resource = card_res
		player_hand.add_to_discard_pile(card)
		
	player_hand.fill_hand()
