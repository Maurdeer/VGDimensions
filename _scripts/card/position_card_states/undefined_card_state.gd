extends CardState
class_name UndefinedCardState

func enter() -> void:
	card.card_sm.transition_to_state(CardStateMachine.StateType.UNINTERACTABLE)
