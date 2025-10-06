extends EventResource
class_name SwapEvent

@export var first_card_is_calling_card: bool
@export var adjacent_only: bool

func execute(card_ref: Card) -> void:
	var first_card_pos: Vector2i
	var second_card_pos: Vector2i
	if first_card_is_calling_card:
		first_card_pos = card_ref.grid_pos
	else:
		first_card_pos = await GridPositionSelector.Instance.player_select_card()
		
	if adjacent_only:
		var filter: Callable = func(card):
			return (card.grid_pos - first_card_pos).length() == 1
		second_card_pos = await GridPositionSelector.Instance.player_select_card_filter(filter)
	else:
		second_card_pos = await GridPositionSelector.Instance.player_select_card()
		
	if first_card_pos == second_card_pos: return
	RiftGrid.Instance.swap_cards(first_card_pos, second_card_pos)
