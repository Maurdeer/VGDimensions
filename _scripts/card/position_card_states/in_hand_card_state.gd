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
	if card._play_bullets.size() == 1:
		# Execute function right way, no selection needed!
		var success: bool = await card._play_bullets[0].try_execute(card)
		if not success: return
	elif card._play_bullets.size() > 1:
		var select_ui: SelectionUI = card.SELECTION_UI.instantiate()
		get_tree().root.add_child(select_ui)
		var bullet = await select_ui.get_play_selection(card.resource)
		select_ui.queue_free()
		
		var success: bool = await bullet.try_execute(card)
		if not success: return
	else:
		printerr("Card is unplayable!! That shouldn't be the case!")
		return
		
	# Passive Call Now
	card.played.emit(card)
	
func exit() -> void:
	super.exit()
	#card.draggable = false
	
