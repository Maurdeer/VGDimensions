extends StateMachine
class_name CardStateMachine

enum StateType {
	UNINTERACTABLE = 0, 
	IN_HAND, 
	ON_RIFT, 
	SELECTABLE,
	UNSELECTABLE
}

var states: Array[CardState]
func _ready() -> void:
	states.append(UninteractableCardState.new())
	states.append(InHandCardState.new())
	states.append(OnRiftCardState.new())
	states.append(SelectableCardState.new())
	states.append(UnselectableCardState.new())
	
	for state in states:
		add_child(state)

func transition_to_state(state: StateType) -> void:
	_transition_to_state(states[state])
