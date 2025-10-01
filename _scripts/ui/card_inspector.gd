extends Node
class_name CardInspector
@onready var clickable_card_visualizer: ClickableCardVisualizer = $clickable_card_visualizer
var card_ref: Card
static var Instance: CardInspector
		
func _ready() -> void:
	Instance = self

func set_card(card: Card):
	pass
	#card_ref = card
	#
	#if card.grid_pos and (card.grid_pos.x >= 0 or card.grid_pos.y >= 0):
		#clickable_card_visualizer.interact_active = true
		#clickable_card_visualizer.play_active = false
	#else:
		#clickable_card_visualizer.interact_active = false
		#clickable_card_visualizer.play_active = card.playable
	#
	#clickable_card_visualizer.card_resource = card.resource
