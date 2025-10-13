extends CardState
class_name InHandCardState

func enter() -> void:
	card.card_sm.transition_to_state(CardStateMachine.StateType.INTERACTABLE)
	gridcard_visualizer.visible = false
	gridcard_back.visible = false
	gridcard_shape.disabled = true
	
	card_visualizer.visible = true
	card_back.visible = true
	card_shape.disabled = false
	card.flip_reveal()
	
func clicked_on() -> void:
	if card.play_bullets.size() == 1:
		# Execute function right way, no selection needed!
		var success: bool = await card.try_execute(card.play_bullets[0], 0)
		if not success: return
	elif card.play_bullets.size() > 1:
		var select_ui: SelectionUI = card.SELECTION_UI.instantiate()
		get_tree().root.add_child(select_ui)
		var selection = await select_ui.get_play_selection(card)
		select_ui.queue_free()
		if not selection: 
			# If Selection didn't give valid results, implies canceled!
			return
		var success: bool = await card.try_execute(selection[0], selection[1])
		if not success: return
	else:
		printerr("Card is unplayable!! That shouldn't be the case!")
		return
	
func exit() -> void:
	super.exit()
	#card.draggable = false
	
