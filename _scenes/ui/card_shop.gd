extends Control

@export var card_shop_ui_scene: PackedScene
@export var container: Control

func _ready():
	for card in CardManager.Instance.card_resources.values():
		add_card(card)

# Interface to add the cards to the shop
func add_card(card: Card):
	_add_card_to_shop(card)
	

#@rpc("any_peer", "call_local", "reliable")
#func _add_card_rpc(card_name: String):
	
func _add_card_to_shop(card: Card):
	var card_shop_ui: CardShopUI = card_shop_ui_scene.instantiate()
	container.add_child(card_shop_ui)
	card_shop_ui.set_card_reference(card)
