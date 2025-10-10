extends CardState
class_name InQuestCardState

func enter() -> void:
	card.card_sm.transition_to_state(CardStateMachine.StateType.INTERACTABLE)

func clicked_on() -> void:
	if CardViewer.Instance: CardViewer.Instance.view_card(card.resource)
