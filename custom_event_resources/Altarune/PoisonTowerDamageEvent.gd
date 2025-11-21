extends EventResource
class_name PoisonTowerDamageEvent

var amount : int = 1

func on_execute() -> bool:
	var curr_pos : Vector2i = m_card_invoker.grid_pos
	var targetedCards : Array[Card]
	
	# Get all diagonal and adjacent cards
	#print("attempting the thing")
	targetedCards.append_array(RiftGrid.Instance.get_diagonal_cards(curr_pos))
	targetedCards.append_array(RiftGrid.Instance.get_adjacent_cards(curr_pos))
	#print(targetedCards.size())
	
	for i in targetedCards.size():
		#print("Is this even running")
		var card_pos : Vector2i = targetedCards[i].grid_pos
		var defeated: bool = targetedCards[i].damage(amount)
		if defeated: RiftGrid.Instance.draw_card(card_pos)

	return false
	
func required_events() -> Array[EventResource]:
	return []
