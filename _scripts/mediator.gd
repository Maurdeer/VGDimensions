extends Node2D
# The class the handles the interactions between cards and the rift grid
# all called in one neat little area
class_name Mediator

static var rift_grid: RiftGrid
static var curr_card: Card			# need this temporarily for placing new cards on the rift_grid
static var card1_pos: Vector2		# the card calling the action
static var user_input: Vector2		# the rift tile clicked on by the player

func _ready() -> void:
	rift_grid = get_node("RiftGrid")	#TODO not sure if this is right, check later

# TODO: not sure how you guys want to pass me the card position data yet
# so I set up this function for you to manually call if needed
# feel free to change it
static func set_current_card(card_ref: Card) -> void:
	curr_card = card_ref
	card1_pos = card_ref.grid_pos

static func get_user_input() -> void:
	user_input = Vector2(0,0)	#TODO: call whatever function is going to be used for that user input. replace the (0,0)

# Waits for the user to click on a rift_grid node before continuing
static func wait_confirmation():
	print("waiting for user input")
	# TODO: something like await $UserClick.click_confirmed or wtv it ends up being
	# or maybe i have to await for the get user input im really not sure yet
	print("user input confirmed")
	return true

static func swap_card(card_ref: Card) -> void:
	set_current_card(card_ref)
	await wait_confirmation()		# wait until user input is finished
	#TODO: probably add a catch if the rift grid says the move is illegal
	rift_grid.swapCards(card1_pos.x, card1_pos.y, user_input.x, user_input.y)
	
static func get_card_attribute() -> void:
	rift_grid.getCardAttribute()
	
static func get_card_position() -> void:
	rift_grid.getCardPosition()
	
static func draw_card() -> void:
	await wait_confirmation()
	rift_grid.drawCard(user_input.x, user_input.y)
	
static func place_card() -> void:
	await wait_confirmation()
	rift_grid.placeCard(card1_pos.x, card1_pos.y, curr_card)

static func moveCardOff() -> void:
	await wait_confirmation()
	rift_grid.moveCardOff(card1_pos.x, card1_pos.y)

# static func discard_card() ->
#TODO: i need a way to get the deck on a certain tile of the rift grid to implement this o7

static func remove_card_from_grid() -> void:
	await wait_confirmation()
	rift_grid.removeCardFromGrid(card1_pos.x, card1_pos.y)
	
static func swap_decks() -> void:
	await wait_confirmation()
	rift_grid.swapDecks(card1_pos.x, card1_pos.y, user_input.x, user_input.y)

#TODO: i need more information from the user input to implement these (like targeting deck, and how directions are handled)
#shuffleCardBackInDeck(shuffleCard: Card, targetDeck: Deck):
#shiftCardsHorizontal(startPos: Vector2, leftNotRight: bool, amount: int):
#shiftCardsVertical(startPos: Vector2, upNotDown: bool, amount: int):
#loopCardsHorizontal(startPos: Vector2, leftNotRight: bool, amount: int):
#loopCardsVertical(startPos: Vector2, upNotDown: bool, amount: int):
#revolveCards(): ***IMPLEMENTATION NEEDED***
#refreshCard(): ***IMPLEMENTATION NEEDED***
#exchangeCard(): ***IMPLEMENTATION NEEDED***
