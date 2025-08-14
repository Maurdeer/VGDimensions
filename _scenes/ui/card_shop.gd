extends Control
class_name CardShop

static var Instance: CardShop
@export var card_shop_ui_scene: PackedScene
@export var container: Control
@onready var spawner: MultiplayerSpawner = $"../MultiplayerSpawner"
const max_shop_size: int = 3
var m_card_ids: Array[String]
var m_cards: Array[Card]

func fill_up_shop() -> void:
	if not multiplayer.is_server(): return
	for i in range(max_shop_size):
		var card = CardManager.Instance.card_resources.values().pick_random()
		rpc("add_card", card.name)

# Interface to add the cards to the shop
@rpc("any_peer", "call_local", "reliable")
func add_card(card_res_id: String):
	var card_res: Card = CardManager.Instance.card_resources[card_res_id]
	var card_shop_ui: CardShopUI = card_shop_ui_scene.instantiate()
	container.add_child(card_shop_ui)
	card_shop_ui.set_card_reference(card_res)
	m_card_ids.append(card_res.name)
	m_cards.append(card_res)

@rpc("any_peer", "call_local", "reliable")
func remove_card(card_res_id: String):
	var card_res: Card = CardManager.Instance.card_resources[card_res_id]
	m_card_ids.erase(card_res.name)
	m_cards.erase(card_res)

@rpc("any_peer", "call_remote", "reliable")
func refresh_shop(p_card_ids: Array[String]):
	_remove_all_cards()
	for id in p_card_ids:
		add_card(id)

func update_shops_with_this_shop() -> void:
	rpc("refresh_shop", m_card_ids) 
	
	
func _remove_all_cards() -> void:
	for i in range(m_cards.size()):
		m_cards[i].queue_free()
	
	m_cards.clear()
	m_card_ids.clear()
	
func _enter_tree() -> void:
	_singleton_init()

func _singleton_init() -> void:
	if Instance:
		queue_free()
		return
	Instance = self
