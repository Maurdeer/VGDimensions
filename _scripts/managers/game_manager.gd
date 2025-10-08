extends Node
class_name GameManager

signal on_start_of_turn
signal on_end_of_turn

@export_category("Initialization Specs")
@export var cards: Array[CardResource]
@export var card_pack: CardPackResource
@export var shop_initial_packs: Array[CardPackResource]
@export var initial_grid_size: Vector2i = Vector2i(3, 3)

@export_category("Developer Tests")
@export var infinite_resources: bool = false

@onready var player_hand: PlayerHand = $PlayerHandUI/player_hand
@onready var rift_grid: RiftGrid = $RiftGrid
const CARD = preload("uid://c3e8058lwu0a")
static var Instance: GameManager

func _ready() -> void:
	# Initialize Singleton
	if Instance: 
		queue_free()
		return
	Instance = self
	
	call_deferred("_after_ready")

func _after_ready() -> void:
	setup_card_shop()
	setup_rift_grid()
	create_cards_for_player_hand()
	
	if infinite_resources: dev_infinite_resources()
	else: initial_player_stats()
	
	# TODO: Change the spot of this
	start_local_play_turn()
	on_start_of_turn.emit() 
	
func setup_card_shop():
	var shop_cards: Array[Card] = CardManager.create_cards_from_packs(shop_initial_packs)
	CardShop.fill_shop_deck(shop_cards)
	
	
func setup_rift_grid():
	var rift_cards: Array[Card] = CardManager.create_cards_from_packs([card_pack])
	rift_grid.generate_new_grid(rift_cards,3,3)
	
func create_cards_for_player_hand():
	var player_hand_cards: Array[Card] = CardManager.create_cards(cards)
	for card in player_hand_cards:
		player_hand.discard_card(card)
		
	player_hand.fill_hand()
	
func initial_player_stats():
	PlayerStatistics.deleons = 10
	PlayerStatistics.actions = 0
	PlayerStatistics.socials = 0
	
func reset_temporary_resources():
	PlayerStatistics.actions = 0
	PlayerStatistics.socials = 0

func dev_infinite_resources():
	PlayerStatistics.deleons = 9999
	PlayerStatistics.actions = 9999
	PlayerStatistics.socials = 9999

func _on_next_turn_button_pressed() -> void:
	# TODO: For multiplayer swap to the next turn instead! 
	end_local_play_turn()
	on_end_of_turn.emit() # Invoked by and seen by all players
	start_local_play_turn()
	on_start_of_turn.emit() # Invoked by and seen by all players
	
func start_local_play_turn() -> void:
	pass
	
func end_local_play_turn() -> void:
	player_hand.clear_hand()
	player_hand.fill_hand()
	
	if infinite_resources: dev_infinite_resources()
	else: reset_temporary_resources()
	
