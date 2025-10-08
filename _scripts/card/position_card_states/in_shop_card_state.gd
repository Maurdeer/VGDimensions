extends CardState
class_name InShopCardState

func enter() -> void:
	card.flip_reveal()
	card.card_sm.transition_to_state(CardStateMachine.StateType.INTERACTABLE)

func clicked_on() -> void:
	CardShop.process_purchase(card)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
