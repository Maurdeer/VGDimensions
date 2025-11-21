extends EventResource
class_name MinigunTowerDamageEvent

var selection_type: SelectionEventResource.SelectionType = SelectionEventResource.SelectionType.RIFT
@export var amount : int = 2
const target_card_at: int = 0

func on_execute() -> bool:
# Deal 2 damage to all enemies diagonal to this card. Switch between diagonal and adjacent
# RiftGrid.Instance.draw_card(selected_card_pos)
	var selected_card_pos = m_card_refs[target_card_at].grid_pos
	#var curr_pos : Vector2i = m_card_invoker.grid_pos
	var targetedCards : Array[Card]
#		First get all cards that are diagonal to the card
	targetedCards.append(RiftGrid.Instance.get_top_card(selected_card_pos))
	targetedCards.append_array(RiftGrid.Instance.get_adjacent_cards(selected_card_pos))
		
	for i in targetedCards.size():
		var card_pos : Vector2i = targetedCards[i].grid_pos
		#print("Dealing damage to card position %d", targetedCards[i].grid_pos)
		var defeated: bool = targetedCards[i].damage(amount)
		if defeated: RiftGrid.Instance.draw_card(card_pos)

	return false
	
func required_events() -> Array[EventResource]:
	var selection: SelectionEventResource = SelectionEventResource.new()
	selection.store_at = target_card_at
	selection.type = selection_type
	return [selection]
