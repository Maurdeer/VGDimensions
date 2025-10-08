extends EventResource
class_name DiscardSelf

const CARD = preload("res://_scenes/card/card.tscn")
@export var replaceSelfWithTarget : bool = false
@export var other_card: CardResource

func execute(card_ref: Card) -> bool:
	#var card_pos: Vector2i = card_ref.grid_pos
	if !replaceSelfWithTarget: RiftGrid.Instance.discard_card_and_draw(card_ref.grid_pos)
	else:
		# This case should occur when they 
		var card_post = card_ref.grid_pos
		RiftGrid.Instance.discard_card(card_ref.grid_pos)
		var card: Card = CARD.instantiate()
		card.resource = other_card
		card.temporary = true
		RiftGrid.Instance.place_card(card_post, card)
	return true
