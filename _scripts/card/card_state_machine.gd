extends Node
class_name CardStateMachine

enum StateType {
	# Interaction States
	UNINTERACTABLE = 0, 
	UNSELECTABLE,
	INTERACTABLE,
	SELECTABLE,
	DRAGGABLE,
	
	# Position States
	UNDEFINED,
	IN_HAND, 
	IN_RIFT, 
	IN_SHOP,
	IN_DECK,
}

var interaction_states: Array[CardState] = [
		UninteractableCardState.new(),
		UnselectableCardState.new(),
		InteractableCardState.new(),
		SelectableCardState.new(),
		DraggableCardState.new(),
	]
var position_states: Array[CardState] = [
		UndefinedCardState.new(),
		InHandCardState.new(),
		InRiftCardState.new(),
		InShopCardState.new()
	]
var interaction_sm: StateMachine = StateMachine.new()
var position_sm: StateMachine = StateMachine.new()

# Since we don't want this called muliple
var _initialized: bool = false

func _ready() -> void:
	if _initialized: return
	_initialized = true
	
	add_child(position_sm)
	add_child(interaction_sm)
	
	for state in interaction_states:
		interaction_sm.add_child(state)
	
	for state in position_states:
		position_sm.add_child(state)
		
func clicked_on() -> void:
	if interaction_sm.current_state is SelectableCardState: 
		(interaction_sm.current_state as CardState).clicked_on()
	elif position_sm.current_state is CardState:
		(position_sm.current_state as CardState).clicked_on()

func transition_to_state(type: StateType) -> void:
	if int(type) < interaction_states.size() : 
		interaction_sm.transition_to_state(interaction_states[type])
	else: 
		position_sm.transition_to_state(position_states[type - interaction_states.size()])
	
func is_state(type: StateType) -> bool:
	if int(type) < interaction_states.size() : return interaction_sm.is_state(interaction_states[type])
	return position_sm.is_state(position_states[type - interaction_states.size()])
	
