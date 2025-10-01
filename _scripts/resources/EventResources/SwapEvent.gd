extends EventResource
class_name SwapEvent

@export var first_card_is_calling_card: bool
@export var adjacent_only: bool

func execute() -> void:
	var first_card_pos: Vector2i
	if first_card_is_calling_card:
		first_card_pos = card_ref.grid_pos
	else:
		GridPositionSelector.Instance.player_select_card()
		await GridPositionSelector.Instance.selected
		first_card_pos = GridPositionSelector.Instance.selected_pos
		
	if adjacent_only:
		GridPositionSelector.Instance.player_select_card_adj_to_position(first_card_pos)
	else:
		GridPositionSelector.Instance.player_select_card()
		
	await GridPositionSelector.Instance.selected
	var second_card_pos: Vector2i = GridPositionSelector.Instance.selected_pos
	
	if first_card_pos == second_card_pos: return
	RiftGrid.Instance.swap_cards(first_card_pos, second_card_pos)
