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
	prev_state = current_state
	if current_state: current_state.exit()
	current_state = new_state
	current_state.enter()
	
func transition_to_prev_state() -> void:
	if not prev_state: return
	transition_to_state(prev_state)
