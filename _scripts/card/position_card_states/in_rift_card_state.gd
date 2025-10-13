extends CardState
class_name InRiftCardState

func enter() -> void:
	card.refresh_stats()
	gridcard_visualizer.visible = true
	gridcard_back.visible = true
	gridcard_shape.disabled = false
	
	card_visualizer.visible = false
	card_back.visible = false
	card_shape.disabled = true
	card.card_sm.transition_to_state(CardStateMachine.StateType.INTERACTABLE)
	card.flip_reveal()
	
func clicked_on() -> void:
	var select_ui: SelectionUI = card.SELECTION_UI.instantiate()
	get_tree().root.add_child(select_ui)
	var selection = await select_ui.get_interaction_selection(card)
	select_ui.queue_free()
	if not selection: 
		# If Selection didn't give valid results, implies canceled!
		return
	var success: bool = await card.try_execute(selection[0], selection[1])
	if not success: return
	card.interacted.emit(card)
	
func exit() -> void:
	gridcard_visualizer.visible = false
	gridcard_back.visible = false
	gridcard_shape.disabled = true
	
	card_visualizer.visible = true
	card_back.visible = true
	card_shape.disabled = false
