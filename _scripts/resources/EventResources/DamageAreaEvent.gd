extends EventResource
class_name DamageAreaEvent

enum area {ROW, COLUMN, ALL}
@export var selection_type: SelectionEventResource.SelectionType = SelectionEventResource.SelectionType.RIFT
@export var amount: int
@export var widthOfArea: int 
@export var heightOfArea: int
const target_card_at: int = 0

func on_execute() -> bool:
	var selected_card_pos: Vector2i = Vector2i(0, 0)
	if (widthOfArea < 5 && heightOfArea < 5):
		selected_card_pos = m_card_refs[target_card_at].grid_pos
	for i in range(widthOfArea):
		if (i + selected_card_pos.x >= RiftGrid.Instance.rift_grid_width):
			break
		for j in range(heightOfArea):
			if (j + selected_card_pos.y >= RiftGrid.Instance.rift_grid_height):
				break
			RiftGrid.Instance.damage_card(selected_card_pos + Vector2i(i, j), amount)
			# TODO: Add a check for if the card is itself.
	
	RiftGrid.Instance.fill_empty_decks()
	
	return false
	
func required_events() -> Array[EventResource]:
	if (widthOfArea >= 5 && heightOfArea >= 5):
		return []
	var selection: SelectionEventResource = SelectionEventResource.new()
	selection.store_at = target_card_at
	selection.type = selection_type
	return [selection]
