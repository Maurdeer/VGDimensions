extends Area2D
class_name DropSlot2D

#signal on_drop(dnd_comp: DragAndDropComponent2D)

## Gurantee that a DragAndDropComponent2D is being dropped on this slot!
func drop(dnd_comp: DragAndDropComponent2D) -> void:
	if not dnd_comp: return
	var card: Card = dnd_comp.get_parent() as Card
	if not card: return
	#if card.play_bullets.size() == 1:
		## Execute function right way, no selection needed!
		#var success: bool = await card.try_execute(card.play_bullets[0], 0)
		#if not success: return
	if card.play_bullets.size() > 0:
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
		
	if card.card_sm.is_state(CardStateMachine.StateType.IN_RIFT):
		PlayerHand.Instance.remove_card_from_hand(card)
	else:
		PlayerHand.Instance.discard_card(card)
