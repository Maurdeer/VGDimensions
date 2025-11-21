extends EventResource
class_name BulletMovementEvent

@export var amount: int = 1

const this_bullet: int = 0
#const card_to_place: int = 0

func find_new_bullet_location(card : Card, direction : Card.CardDirection) -> Vector2i:
	var new_loc : Vector2i = card.grid_pos
	match direction:
		Card.CardDirection.NORTH:
			new_loc += Vector2i(0, -1)
		Card.CardDirection.SOUTH:
			new_loc += Vector2i(0, 1)
		Card.CardDirection.EAST:
			new_loc += Vector2i(1, 0)
		Card.CardDirection.WEST:
			new_loc += Vector2i(-1, 0)
	return new_loc

func on_execute() -> bool:
	var curr_bullet: Card = m_card_refs[this_bullet]
	#var curr_bullet: Card = m_card_refs[card_to_place]
	var curr_direction : Card.CardDirection = curr_bullet.card_dir
	var target_loc : Vector2i = find_new_bullet_location(curr_bullet, curr_direction)
	#print("This bullet is at ", curr_bullet.grid_pos)
	if (RiftGrid.Instance.is_valid_pos(target_loc)):
		#var temp_location : Vector2i = curr_bullet.grid_pos
		var card_at_loc : Card = RiftGrid.Instance.get_top_card(target_loc)
		# TODO: Make this not damage Willow Cards
		if ((card_at_loc.resource.type == CardResource.CardType.ENEMY or \
		card_at_loc.resource.type == CardResource.CardType.ALLY)):
			var defeated : bool = RiftGrid.Instance.damage_card(target_loc, amount)
			if defeated: RiftGrid.Instance.draw_card_if_empty(target_loc)
			RiftGrid.Instance.discard_card_and_draw(curr_bullet)
		else:
			RiftGrid.Instance.move_card_to(target_loc, curr_bullet.grid_pos)
		#RiftGrid.Instance.draw_card_if_empty(temp_location)
	else:
		RiftGrid.Instance.discard_card_and_draw(curr_bullet)
	return false
	
func required_events() -> Array[EventResource]:
	var selection: SelectionEventResource = SelectionEventResource.new()
	selection.type = SelectionEventResource.SelectionType.SELF
	selection.store_at = this_bullet
	return [selection]
