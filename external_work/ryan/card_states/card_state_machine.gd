extends Node
class_name CardStateMachine

enum StateType {
	# Interaction States
	UNINTERACTABLE = 0, 
	INTERACTABLE,
	UNSELECTABLE,
	SELECTABLE,
	
	# Position States
	UNDEFINED,
	IN_HAND, 
	ON_RIFT, 
}

var interaction_states: Array[CardState]
var position_states: Array[CardState]
var interaction_sm: StateMachine
var position_sm: StateMachine

func _ready() -> void:
	position_sm = StateMachine.new()
	interaction_sm = StateMachine.new()
	
	add_child(position_sm)
	add_child(interaction_sm)
	
	interaction_states.append(UninteractableCardState.new())
	interaction_states.append(InteractableCardState.new())
	interaction_states.append(UnselectableCardState.new())
	interaction_states.append(SelectableCardState.new())
	
	for state in interaction_states:
		interaction_sm.add_child(state)
	
	position_states.append(UndefinedCardState.new())
	position_states.append(InHandCardState.new())
	position_states.append(OnRiftCardState.new())
	
	
	for state in position_states:
		position_sm.add_child(state)
		
func clicked_on() -> void:
	if position_sm.current_state is CardState: (position_sm.current_state as CardState).clicked_on()
	if interaction_sm.current_state is CardState: (interaction_sm.current_state as CardState).clicked_on()

func transition_to_state(type: StateType) -> void:
	if int(type) < interaction_states.size() : interaction_sm.transition_to_state(interaction_states[type])
	else: position_sm.transition_to_state(interaction_states[type - interaction_states.size()])
	
