extends Node
class_name GameManager

@export var cards: Array[CardResource]
@export var card_pack: CardPackResource
@export var shop_initial_packs: Array[CardPackResource]
@onready var player_hand: PlayerHand = $PlayerHandUI/player_hand
@onready var rift_grid: RiftGrid = $RiftGrid
const CARD = preload("uid://c3e8058lwu0a")

func _ready() -> void:
	CardShop.fill_shop_deck(shop_initial_packs)
	call_deferred("_after_ready")

func _after_ready() -> void:
	setup_rift_grid()
	create_cards_for_player_hand()
	initial_player_stats()
	
func setup_rift_grid():
	rift_grid.rift_card_pack = card_pack
	rift_grid.rift_grid_height = 4
	rift_grid.rift_grid_width = 4
	rift_grid.draw_initial_grid()
	
func create_cards_for_player_hand():
	for card_res in cards:
		var card: Card = CARD.instantiate()
		card.resource = card_res
		player_hand.discard_card(card)
		
	player_hand.fill_hand()
	
func initial_player_stats():
	PlayerStatistics.replace_base_resource(PlayerStatistics.ResourceType.DELEON, 10)
	PlayerStatistics.replace_base_resource(PlayerStatistics.ResourceType.ACTION, 0)
	PlayerStatistics.replace_base_resource(PlayerStatistics.ResourceType.SOCIAL, 0)
	
func reset_temporary_resources():
	PlayerStatistics.replace_base_resource(PlayerStatistics.ResourceType.ACTION, 0)
	PlayerStatistics.replace_base_resource(PlayerStatistics.ResourceType.SOCIAL, 0)

func _on_next_turn_button_pressed() -> void:
	player_hand.clear_hand()
	player_hand.fill_hand()
	reset_temporary_resources()
