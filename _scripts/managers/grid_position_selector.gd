extends Node
class_name GridPositionSelector

@onready var rift_grid: RiftGrid = $".."

static var Instance: GridPositionSelector

var _first: bool
var _selected_pos: Vector2i
var _is_selection_active: bool = false
signal selected

func _ready() -> void:
	# Initialize Singleton
	if Instance: 
		queue_free()
		return
	Instance = self

func player_select_card() -> Vector2i:
	if _is_selection_active: 
		return Vector2i(-1, -1)
	_is_selection_active = true
	_first = true
	for i in rift_grid.rift_grid_height:
		for deck: Deck in rift_grid.grid[i]:
			if deck.is_empty(): continue
			var card: Card = deck.get_top_card()
			card.card_sm.transition_to_state(CardStateMachine.StateType.SELECTABLE)
			card.selected.connect(on_card_clicked)
	
	PlayerHand.Instance.disable_player_hand()
	await selected
	PlayerHand.Instance.enable_player_hand()
	_is_selection_active = false
	return _selected_pos
	
func player_select_card_filter(filter: Callable = func(card: Card): return true) -> Vector2i:
	if _is_selection_active: return Vector2i(-1, -1)
	_is_selection_active = true
	_first = true
	var no_cards_connected: bool = true
	for i in rift_grid.rift_grid_height:
		for deck: Deck in rift_grid.grid[i]:
			var card: Card = deck.get_top_card()
			if filter.call(card):
				card.card_sm.transition_to_state(CardStateMachine.StateType.SELECTABLE)
				no_cards_connected = false
			else:
				card.card_sm.transition_to_state(CardStateMachine.StateType.UNSELECTABLE)
			card.selected.connect(on_card_clicked)
			
	if no_cards_connected:
		revert_card_states()
		_is_selection_active = false
		return Vector2i(-1, -1)
	
	PlayerHand.Instance.disable_player_hand()
	await selected
	PlayerHand.Instance.enable_player_hand()
	_is_selection_active = false
	return _selected_pos
		
func revert_card_states() -> void:
	for i in rift_grid.rift_grid_height:
		for deck: Deck in rift_grid.grid[i]:
			var card: Card = deck.get_top_card()
			card.card_sm.interaction_sm.transition_to_prev_state()
			card.selected.disconnect(on_card_clicked)
			
func on_card_clicked(grid_pos: Vector2i):
	if not _first: return
	_first = false
	revert_card_states()
	_selected_pos = grid_pos
	selected.emit()
