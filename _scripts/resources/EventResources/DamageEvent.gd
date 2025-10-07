extends EventResource
class_name DamageEvent

@export var amount: int
@export var damage_self: bool = false

func execute(card_ref: Card) -> bool:
	var selected_card_pos: Vector2i 
	if damage_self:
		selected_card_pos = card_ref.grid_pos
	else:
		selected_card_pos = await GridPositionSelector.Instance.player_select_card()
	
	RiftGrid.Instance.damage_card(selected_card_pos, amount)
	return true
