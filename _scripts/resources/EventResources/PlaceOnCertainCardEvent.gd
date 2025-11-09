extends EventResource
class_name PlaceOnCertainCardEvent

@export var source_selection_type: SelectionEventResource.SelectionType
@export var only_adjacent_cards: bool = false
@export var other_card_resource: CardResource
@export var select_position_card_resource: CardResource
const card_to_place: int = 0
const location_to_place: int = 1

func on_execute() -> bool:
	var source_card: Card = m_card_refs[card_to_place]
	var selected_pos: Vector2i = m_card_refs[location_to_place].grid_pos
	if other_card_resource:
		# (Ryan) Since events are not responsible of invoking rpcs, 
		# we do local calls from now on 
		source_card = CardManager.create_card_locally(other_card_resource, true)
		RiftGrid.Instance.place_card(selected_pos, source_card)
		return false

	if source_card.card_sm.is_state(CardStateMachine.StateType.IN_RIFT):
		# Just move the cards within the rift
		RiftGrid.Instance.move_card_to(selected_pos, source_card.grid_pos)
		RiftGrid.Instance.draw_card_if_empty(source_card.grid_pos)
	else:
		# The Card was not in the rift grid yet, so just place it in the new spot
		RiftGrid.Instance.place_card(selected_pos, source_card)
	return false

func required_events() -> Array[EventResource]:
	# Where are we grabbing this card from?
	var source_card_selection: SelectionEventResource = SelectionEventResource.new()
	source_card_selection.store_at = card_to_place
	source_card_selection.type = source_selection_type
	
	# The location to place the card is always on the Rift
	var location_to_place_selection: SelectionEventResource = SelectionEventResource.new()
	location_to_place_selection.store_at = location_to_place
	location_to_place_selection.type = SelectionEventResource.SelectionType.RIFT
	if only_adjacent_cards:
		location_to_place_selection.filter = RiftCardSelector.Instance.adjacent_only(m_card_invoker)
	if select_position_card_resource != null:
		location_to_place_selection.filter = RiftCardSelector.Instance.select_sepcific_card(select_position_card_resource)
	return [source_card_selection, location_to_place_selection]
