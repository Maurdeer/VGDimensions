extends EventResource
class_name FurnaceTowerDamageEvent

var amount : int = 2
var isDiagonal : bool = true

func on_execute() -> bool:
# Deal 2 damage to all enemies diagonal to this card. Switch between diagonal and adjacent
# RiftGrid.Instance.draw_card(selected_card_pos)
	var curr_pos : Vector2i = m_card_invoker.grid_pos
	var targetedCards : Array[Card]

#	Grab either the diagonal or adjacent cards
	if (isDiagonal):
		targetedCards.append_array(RiftGrid.Instance.get_diagonal_cards(curr_pos))
	else:
		targetedCards.append_array(RiftGrid.Instance.get_adjacent_cards(curr_pos))
	
	for i in targetedCards.size():
		var card_pos : Vector2i = targetedCards[i].grid_pos
		var defeated: bool = targetedCards[i].damage(amount)
		if defeated: RiftGrid.Instance.draw_card(card_pos)
	
#	Toggle Diagonal
	isDiagonal = !isDiagonal
	#print("Furance Tower Went Off")
	return false
	
func required_events() -> Array[EventResource]:
	return []
