extends Control
class_name CardShop

static var Instance: CardShop
@export var card_shop_ui_scene: PackedScene
@export var container: Control
@onready var spawner: MultiplayerSpawner = $"../MultiplayerSpawner"
var spawn_function
const max_shop_size: int = 3

func _ready() -> void:
	spawn_function = func(data):
		var card_name: String = data[0]
		var card_res: Card = CardManager.Instance.card_resources[card_name]
		var card_shop_ui: CardShopUI = card_shop_ui_scene.instantiate()
		container.add_child(card_shop_ui)
		card_shop_ui.set_card_reference(card_res)
		return card_shop_ui

func fill_up_shop() -> void:
	if not multiplayer.is_server(): return
	for i in range(max_shop_size):
		var card = CardManager.Instance.card_resources.values().pick_random()
		add_card(card)

# Interface to add the cards to the shop
func add_card(card: Card):
	spawner.spawn_function = spawn_function
	spawner.spawn([card.name])

#@rpc("any_peer", "call_local", "reliable")
#func _add_card_rpc(card_name: String):
	
func _enter_tree() -> void:
	_singleton_init()

func _singleton_init() -> void:
	if Instance:
		queue_free()
		return
	Instance = self
