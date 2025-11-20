extends CardState
class_name InDeckCardState

func enter() -> void:
	card.card_sm.transition_to_state(CardStateMachine.StateType.INTERACTABLE)
	gridcard_visualizer.visible = false
	gridcard_back.visible = false
	gridcard_shape.visible = true
	
	card_visualizer.visible = true
	card_back.visible = true
	card_shape.visible = false
	#card.flip_reveal()
	
func exit() -> void:
	super.exit()
	#card.draggable = false
	
