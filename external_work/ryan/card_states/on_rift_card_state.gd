extends CardState
class_name OnRiftCardState

func enter() -> void:
	gridcard_visualizer.visible = true
	gridcard_back.visible = true
	gridcard_shape.disabled = false
	
	card_visualizer.visible = false
	card_back.visible = false
	card_shape.disabled = true
	
	card.flip_reveal()
	
func clicked_on() -> void:
	var select_ui: SelectionUI = card.SELECTION_UI.instantiate()
	get_tree().root.add_child(select_ui)
	select_ui.setup_interaction_selections(card.resource)
	await select_ui.selection_complete
	card.interacted.emit(card)
	
