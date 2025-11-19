extends Node
class_name RiftCardSelector

@onready var rift_grid: RiftGrid = $".."

static var Instance: RiftCardSelector

var _first: bool
var _selected_card: Card
var _is_selection_active: bool = false
signal selected

func _ready() -> void:
	# Initialize Singleton
	if Instance: 
		queue_free()
		return
	Instance = self
	
func player_select_card(cancellable: bool, filter: Callable = func(card: Card): return true) -> Card:
	if _is_selection_active: return null
	_is_selection_active = true
	_first = true
	var no_cards_connected: bool = true
	
	# Effects to do on Selectable
	for i in rift_grid.rift_grid_height:
		for deck: Deck in rift_grid.grid[i]:
			var card: Card = deck.get_top_card()
			if not card: continue
			if card.card_sm.is_state(CardStateMachine.StateType.INTERACTABLE) and filter.call(card):
				card.card_sm.transition_to_state(CardStateMachine.StateType.SELECTABLE)
				no_cards_connected = false
			else:
				card.card_sm.transition_to_state(CardStateMachine.StateType.UNSELECTABLE)
			card.selected.connect(on_card_clicked)
			
	if no_cards_connected:
		revert_card_states()
		_is_selection_active = false
		return null
	
	# TODO: State swapping instead?
	GameManager.Instance.next_turn_button.visible = false
	PlayerHand.Instance.disable_player_hand()
	await selected
	GameManager.Instance.next_turn_button.visible = true
	PlayerHand.Instance.enable_player_hand()
	# =====================================
	_is_selection_active = false
	return _selected_card
		
func revert_card_states() -> void:
	for i in rift_grid.rift_grid_height:
		for deck: Deck in rift_grid.grid[i]:
			if deck.is_empty(): continue
			var card: Card = deck.get_top_card()
			card.card_sm.interaction_sm.transition_to_prev_state()
			card.selected.disconnect(on_card_clicked)
			
func on_card_clicked(card: Card):
	if card.grid_pos.x < 0 and card.grid_pos.y < 0:
		# Not on the rift grid, thus invalid
		return
	if not _first: return
	_first = false
	revert_card_states()
	_selected_card = card
	selected.emit()
	
# ====== Filters you can use =========
func adjacent_only(from_card: Card) -> Callable:
	return func(card: Card): return (card.grid_pos - from_card.grid_pos).length() == 1

func select_sepcific_card(select_card : CardResource) -> Callable:
	return func(card: Card): return card.resource.title == select_card.title
		
