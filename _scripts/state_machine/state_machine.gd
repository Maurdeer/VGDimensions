extends Node
class_name StateMachine

@export var current_state: State 
var prev_state: State

func _process(_delta: float) -> void:
	if not current_state: return
	current_state.update()
	
func _physics_process(_delta: float) -> void:
	if not current_state: return
	current_state.fixed_update()
	
func transition_to_state(new_state: State) -> void:
	if not new_state: 
		printerr("Cannot Transition to Null State")
		return
	if current_state and current_state == new_state: return # Don't transition please!
	prev_state = current_state
	if current_state: current_state.exit()
	current_state = new_state
	current_state.enter()
	
func transition_to_prev_state() -> void:
	if not prev_state or current_state.get_script() == prev_state.get_script(): return
	transition_to_state(prev_state)
	
func is_state(state: State) -> bool:
	return current_state == state
