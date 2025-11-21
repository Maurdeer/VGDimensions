extends EventResource
class_name SwapEvent

@export var source_selection_type: SelectionEventResource.SelectionType
@export var only_adjacent_cards: bool = false
const card_to_place: int = 0
const location_to_place: int = 1

func on_execute() -> bool:
	var source_card: Card = m_card_refs[card_to_place]
	#var source_card_pos: Vector2i = source_card.grid_pos
	var selected_pos: Vector2i = m_card_refs[location_to_place].grid_pos
	if source_card.card_sm.is_state(CardStateMachine.StateType.IN_RIFT):
		# Just move the cards within the rift
		RiftGrid.Instance.swap_cards(source_card.grid_pos, selected_pos)
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
	return [source_card_selection, location_to_place_selection]
