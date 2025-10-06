extends Node

signal card_purchased(card_node: Card)

# The source deck used to draw cards to fill the shop grid.
var shop_source_deck: Array[CardResource]

var current_grid_cards: Array[Card] = []
var input_active: bool = false

const CARD = preload("uid://c3e8058lwu0a")
const SHOP_STATE_SCRIPT = preload("uid://cq7eng5b8vcys")

func fill_shop_deck(pack_resources: Array[CardPackResource]) -> void:
	for pack_res in pack_resources:
		if pack_res:
			var card_map: Dictionary = pack_res.card_resources
			
			# Loop through the Dict of CardResource keys and their quantities (values)
			for card_resource in pack_res.card_resources.keys():
				var count: int = card_map[card_resource]
				for _i in range(count):
					shop_source_deck.append(card_resource)
	print("CardShop: Initialized deck with ", shop_source_deck, " card pack(s).")

func set_input_active(is_active: bool) -> void:
	input_active = is_active
	print("CardShop: Input is now active: ", input_active)
	
func return_six_cards() -> Array[Card]:
	for i in range(6):
		var card_res: CardResource = shop_source_deck.pop_front()
		var new_card: Card = CARD.instantiate()
	
		new_card.resource = card_res

		current_grid_cards.append(new_card)
	print("CardShop: Drew ", current_grid_cards.size(), " cards for the grid.")
	return current_grid_cards

func process_purchase(card_to_purchase: Card) -> void:
	var index = current_grid_cards.find(card_to_purchase)
	if index == -1:
		printerr("CardShop: ERROR! Attempted to purchase card not found in grid array.")	
	current_grid_cards.remove_at(index)
	print("CardShop: Card removed from grid array. Remaining:", current_grid_cards.size())
	
	# Emit the signal to tell the UI to update
	emit_signal("card_purchased", card_to_purchase)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
