extends Node
class_name GridPositionSelector

@onready var rift_grid: RiftGrid = $".."

static var Instance: GridPositionSelector

var _first: bool
var _selected_pos: Vector2i
signal selected

func _ready() -> void:
	# Initialize Singleton
	if Instance: 
		queue_free()
		return
	Instance = self
	
func player_select_card_adj_to_position(pos: Vector2i) -> Vector2i:
	_first = true
	for i in rift_grid.rift_grid_height:
		for deck: Deck in rift_grid.grid[i]:
			var card: Card = deck.get_top_card()
			if (card.grid_pos - pos).length() == 1:
				card.card_sm.transition_to_state(CardStateMachine.StateType.SELECTABLE)
			else:
				card.card_sm.transition_to_state(CardStateMachine.StateType.UNSELECTABLE)
			card.selected.connect(on_card_clicked)
			
	await selected
	return _selected_pos

func player_select_card() -> Vector2i:
	_first = true
	for i in rift_grid.rift_grid_height:
		for deck: Deck in rift_grid.grid[i]:
			var card: Card = deck.get_top_card()
			
			card.card_sm.transition_to_state(CardStateMachine.StateType.SELECTABLE)
			card.selected.connect(on_card_clicked)
			
	await selected
	return _selected_pos

func on_card_clicked(grid_pos: Vector2i):
	if not _first: return
	_first = false
	
	# TODO: Swap back to the original state of all the cards
	# Handle this in the state machine of card instead of here
	# For now just set them to interactable since we know they are cards on
	# the grid.
	for i in rift_grid.rift_grid_height:
		for deck: Deck in rift_grid.grid[i]:
			var card: Card = deck.get_top_card()
			
			# TODO: Replace with State Swapping
			card.card_sm.transition_to_prev_state()
			card.selected.disconnect(on_card_clicked)
	_selected_pos = grid_pos
	selected.emit()
