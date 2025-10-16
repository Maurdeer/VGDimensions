extends CardState
class_name InShopCardState

func enter() -> void:
	card.flip_reveal()
	card.card_sm.transition_to_state(CardStateMachine.StateType.INTERACTABLE)

func clicked_on() -> void:
	CardShop.process_purchase(card)
