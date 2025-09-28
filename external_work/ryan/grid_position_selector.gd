extends Node
class_name GridPositionSelector

@onready var rift_grid: RiftGrid = $".."

static var Instance: GridPositionSelector

var _first: bool
var selected_pos: Vector2i
signal selected

func _ready() -> void:
	# Initialize Singleton
	if Instance: 
		queue_free()
		return
	Instance = self

func player_select_card() -> void:
	_first = true
	for i in rift_grid.getGridYDim():
		for deck: Deck in rift_grid.riftGrid[i]:
			var card: Card = deck.get_top_card()
			
			# TODO: Replace with State Swapping
			card.selectable = true
			card.interactable = false
			card.selected.connect(on_card_clicked)
	
	# TODO: Some kind of highlight vfx over each RiftGridSlot would be nice

func on_card_clicked(grid_pos: Vector2i):
	if not _first: return
	_first = false
	
	# TODO: Swap back to the original state of all the cards
	# Handle this in the state machine of card instead of here
	# For now just set them to interactable since we know they are cards on
	# the grid.
	for i in rift_grid.getGridYDim():
		for deck: Deck in rift_grid.riftGrid[i]:
			var card: Card = deck.get_top_card()
			
			# TODO: Replace with State Swapping
			card.selectable = false
			card.interactable = true
			card.selected.disconnect(on_card_clicked)
	selected_pos = grid_pos
	selected.emit()
