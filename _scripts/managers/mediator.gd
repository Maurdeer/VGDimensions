extends Node2D
## The class the handles the interactions between cards and the rift grid
##
## Currently communication with the mediator handles everything locally
## The future update to this script will make it handle network RPCs to make calls
## State Updates to newly added or returning clients will be managed by an external script
## that this script may communicate with.
## This is why currently its just wrapping around the exact calls as RiftGrid!
class_name Mediator

# Singleton Stuff
static var Instance: Mediator:
	get:
		if not Instance:
			Instance = Mediator.new()
		return Instance
			
var curr_card: Card # need this temporarily for placing new cards on the rift_grid
var card1_pos: Vector2 # the card calling the action
var user_input: Vector2 # the rift tile clicked on by the player

func _ready() -> void:
	if Instance: 
		queue_free()
		return
	Instance = self
	
func request_player_card_selection() -> Vector2:
	# Communicate with card selector and await its input
	
	# (Ryan) Utilize Await right here to wait for the input to come from the user
	# The idea is that this selection would be returned back here
	# You are likely to have this selector come from the rift grid itself.
	return Vector2(0,0)

func swap_card(card_pos_a: Vector2i, card_pos_b: Vector2i) -> void:
	#TODO: probably add a catch if the rift grid says the move is illegal
	RiftGrid.Instance.swapCards(card_pos_a, card_pos_b)
	
func get_card_attribute() -> void:
	RiftGrid.Instance.getCardAttribute()
	
func get_card_position() -> void:
	RiftGrid.Instance.getCardPosition()
	
func draw_card(draw_to: Vector2i) -> void:
	RiftGrid.Instance.drawCard(draw_to)
	
func place_card(place_at: Vector2i, new_card: Card) -> void:
	RiftGrid.Instance.placeCard(place_at, new_card)

func moveCardOff(card_pos: Vector2i) -> Card:
	return RiftGrid.Instance.moveCardOff(card_pos)

# static func discard_card() ->
#TODO: i need a way to get the deck on a certain tile of the rift grid to implement this o7

func remove_card_from_grid(card_pos: Vector2i) -> void:
	RiftGrid.Instance.removeCardFromGrid(card_pos)
	
func swap_decks(deck_pos_a: Vector2i, deck_pos_b: Vector2i) -> void:
	RiftGrid.Instance.swapDecks(deck_pos_a, deck_pos_b)

#TODO: i need more information from the user input to implement these (like targeting deck, and how directions are handled)
#shuffleCardBackInDeck(shuffleCard: Card, targetDeck: Deck):
#shiftCardsHorizontal(startPos: Vector2, leftNotRight: bool, amount: int):
#shiftCardsVertical(startPos: Vector2, upNotDown: bool, amount: int):
#loopCardsHorizontal(startPos: Vector2, leftNotRight: bool, amount: int):
#loopCardsVertical(startPos: Vector2, upNotDown: bool, amount: int):
#revolveCards(): ***IMPLEMENTATION NEEDED***
#refreshCard(): ***IMPLEMENTATION NEEDED***
#exchangeCard(): ***IMPLEMENTATION NEEDED***
