extends Node

# The source deck used to draw cards to fill the shop grid.
var shop_source_deck: Array[Card] = []

var current_grid_cards: Array[Card] = []
var input_active: bool = false
const max_shop_size: int = 6

const CARD = preload("uid://c3e8058lwu0a")

func fill_shop_deck(cards: Array[Card]) -> void:
	for card in cards:
		shop_source_deck.push_back(card)
	print("CardShop: Filled ", shop_source_deck.size(), " to source deck.")
	shop_source_deck.shuffle()

func set_input_active(is_active: bool) -> void:
	input_active = is_active
	print("CardShop: Input is now active: ", input_active)
	
func return_cards() -> Array[Card]:
	while not shop_source_deck.is_empty() and current_grid_cards.size() < max_shop_size:
		var card: Card = shop_source_deck.pop_front()
		current_grid_cards.append(card)
	print("CardShop: Drew ", current_grid_cards.size(), " cards for the grid.")
	return current_grid_cards

func process_purchase(card_to_purchase: Card) -> void:
	var purchase_price: int = card_to_purchase.resource.deleon_value
	if PlayerStatistics.purchase_attempt(PlayerStatistics.ResourceType.DELEON, purchase_price):
		# Add card to discard pile without adding to hand
		PlayerHand.Instance.add_to_discard(card_to_purchase)
		current_grid_cards.erase(card_to_purchase)
		print("CardShop: Card6 removed from grid array. Remaining:", current_grid_cards.size())
		print("price ", purchase_price, "delons", PlayerStatistics.deleons)
	else:
		print("CardShop: Purchase failed! Player cannot afford ", PlayerStatistics.deleons, " deleons (Have: ", PlayerStatistics.deleons, ").")
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# connect to game manager onstartOfEveryTurn
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
