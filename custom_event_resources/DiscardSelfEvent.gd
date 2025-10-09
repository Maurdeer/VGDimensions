extends EventResource
class_name DiscardSelfEvent

@export var other_card: CardResource

func execute(card_ref: Card) -> bool:
	#var card_pos: Vector2i = card_ref.grid_pos
	if other_card == null: 
		RiftGrid.Instance.discard_card_and_draw(card_ref.grid_pos)
	else: 
		var selected_grid_pos = card_ref.grid_pos
		RiftGrid.Instance.discard_card(selected_grid_pos)
		var card = await CardManager.create_card(other_card, true)
		RiftGrid.Instance.place_card(selected_grid_pos, card)
	return true
