extends EventResource
class_name DamageAreaEvent

enum area {ROW, COLUMN, ALL}
@export var amount: int
@export var widthOfArea: int 
@export var heightOfArea: int
@export var target_card_at: int

func on_execute() -> bool:
	var selected_card_pos: Vector2i = m_card_refs[target_card_at].grid_pos
	for i in range(widthOfArea):
		if (i + selected_card_pos.x >= RiftGrid.Instance.rift_grid_width):
			break
		for j in range(heightOfArea):
			if (j + selected_card_pos.y >= RiftGrid.Instance.rift_grid_height):
				break
			await RiftGrid.Instance.damage_card(selected_card_pos + Vector2i(i, j), amount)
	
	RiftGrid.Instance.fill_empty_decks()
	
	return false
