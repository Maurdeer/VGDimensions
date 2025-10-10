extends EventResource
class_name DamageAreaEvent

enum area {ROW, COLUMN, ALL}
@export var amount: int
@export var widthOfArea: int 
@export var heightOfArea: int

#var rift_grid_width: int = 3
#var rift_grid_height: int = 3

func execute(card_ref: Card) -> bool:
	# Maybe this should be linked to the DamageEvent, but ah well
	var selected_card_pos: Vector2i = Vector2i(0, 0)
	if (widthOfArea < 5 && heightOfArea < 5):
		selected_card_pos = await GridPositionSelector.Instance.player_select_card()
	
	print("Width of area is %d and height of area is %d" % [widthOfArea, heightOfArea])
	for i in range(widthOfArea):
		if (i + selected_card_pos.x >= RiftGrid.Instance.rift_grid_width):
			break
		for j in range(heightOfArea):
			if (j + selected_card_pos.y >= RiftGrid.Instance.rift_grid_height):
				break
			await RiftGrid.Instance.damage_card(selected_card_pos + Vector2i(i, j), amount)
	
	RiftGrid.Instance.fill_empty_decks()
	
	return true
