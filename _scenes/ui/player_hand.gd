extends Control
class_name PlayerHand

# [Temp] Singleton
# Justification: This object will only be available to the current client, no one else,
# and no one else needs this information besides the objects interacting in the client
# No networking needed!
static var Instance: PlayerHand

@export var card_ui_scene: PackedScene
@onready var card_region = $card_region


func add_card(card: Card) -> void:
	var card_ui: CardUI = card_ui_scene.instantiate()
	card_region.add_child(card_ui)
	card_ui.set_card_reference(card)
	
func _enter_tree() -> void:
	_singleton_init()

func _singleton_init() -> void:
	if Instance:
		queue_free()
		return
	Instance = self
