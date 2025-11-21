extends EventResource
class_name RespawnCornerCardsEvent

#@export var source_selection_type: SelectionEventResource.SelectionType
#@export var only_adjacent_cards: bool = false
@export var card_1: CardResource
@export var card_2: CardResource

var current_copy_1: Card
var current_copy_2: Card
# Holy M4
# TODO: Implement the idea of ownership by Spring Demo
func on_execute() -> bool:
	print(current_copy_1, " is status and ", current_copy_2, " is status")
	if ((card_1 != null and current_copy_1 == null) or \
	(current_copy_1 != null and current_copy_1.grid_pos == Vector2i(-1, -1))):
		var top_left_card = CardManager.create_card_locally(card_1, true)
		current_copy_1 = top_left_card
		current_copy_1.reset_passive_events()
		RiftGrid.Instance.place_card(Vector2i(0, 0), top_left_card)
	if ((card_2 != null and current_copy_2 == null) or \
	(current_copy_2 != null and current_copy_2.grid_pos == Vector2i(-1, -1))):
		var bottom_right_card = CardManager.create_card_locally(card_2, true)
		current_copy_2 = bottom_right_card
		current_copy_2.reset_passive_events()
		RiftGrid.Instance.place_card(Vector2i(RiftGrid.Instance.rift_grid_width - 1, \
		RiftGrid.Instance.rift_grid_height - 1), bottom_right_card)
	
	return false

func required_events() -> Array[EventResource]:
	# Where are we grabbing this card from?
	return []
