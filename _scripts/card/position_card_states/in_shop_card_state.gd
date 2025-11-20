extends CardState
class_name InShopCardState

func enter() -> void:
	card.flip_reveal()
	card.card_sm.transition_to_state(CardStateMachine.StateType.INTERACTABLE)
	card_visualizer.icons.visible = true

func clicked_on() -> void:
	CardShop.process_purchase(card)
	
func exit() -> void:
	card_visualizer.icons.visible = false
