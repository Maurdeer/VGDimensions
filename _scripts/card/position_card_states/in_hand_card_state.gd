extends CardState
class_name InHandCardState

func enter() -> void:
	card.card_sm.transition_to_state(CardStateMachine.StateType.INTERACTABLE)
	gridcard_visualizer.visible = false
	gridcard_back.visible = false
	card_visualizer.visible = true
	card_back.visible = true
	card.flip_reveal()
	
func clicked_on() -> void:
	if card._play_bullets.size() == 1:
		# Execute function right way, no selection needed!
		await card._play_bullets[0].try_execute()
	elif card._play_bullets.size() > 1:
		# TODO: Pull Up Play Selection UI to pick an event to do.
		# Let the function call poll until that option was picked
		var select_ui: SelectionUI = card.SELECTION_UI.instantiate()
		get_tree().root.add_child(select_ui)
		var bullet = await select_ui.get_play_selection(card.resource)
		select_ui.queue_free()
		
		await bullet.try_execute()
	else:
		printerr("Card is unplayable!! That shouldn't be the case!")
		return
		
	# Passive Call Now
	card.played.emit(card)
	card.resource.on_play()
	
func exit() -> void:
	super.exit()
	#card.draggable = false
	
