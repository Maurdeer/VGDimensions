extends EventResource
class_name SwapEvent

func execute() -> void:
	var first_card_pos: Vector2i = Mediator.Instance.request_player_card_selection()
	var second_card_pos: Vector2i = Mediator.Instance.request_player_card_selection()
	Mediator.Instance.swap_card(first_card_pos, second_card_pos)
