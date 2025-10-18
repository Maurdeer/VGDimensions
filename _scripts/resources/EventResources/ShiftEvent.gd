extends EventResource
class_name ShiftEvent

enum Direction {HORIZONTAL, VERTICAL}
@export var selection_type: SelectionEventResource.SelectionType = SelectionEventResource.SelectionType.RIFT
@export var shift_direction: Direction
@export var amount: int = 1
@export var shift_all: bool = false
const target_card_at: int = 0

func on_execute() -> bool:
	var shift_from = m_card_refs[target_card_at].grid_pos
	if (shift_all):
		match(shift_direction):
			Direction.HORIZONTAL:
				shift_from.x = 0
			Direction.VERTICAL:
				shift_from.y = 0
	match(shift_direction):
		Direction.HORIZONTAL:
			RiftGrid.Instance.shift_decks_horizontally(shift_from, amount)
		Direction.VERTICAL:
			RiftGrid.Instance.shift_decks_vertically(shift_from, amount)
	return false
	
func required_events() -> Array[EventResource]:
	var selection: SelectionEventResource = SelectionEventResource.new()
	selection.store_at = target_card_at
	selection.type = selection_type
	return [selection]
