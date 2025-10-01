extends CardState
class_name OnRiftCardState

func enter() -> void:
	card.flip_reveal()

func clicked_on() -> void:
	var select_ui: SelectionUI = card.SELECTION_UI.instantiate()
	get_tree().root.add_child(select_ui)
	select_ui.setup_interaction_selections(card.resource)
	await select_ui.selection_complete
	card.interacted.emit(card)
