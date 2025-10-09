extends EventResource
class_name ApplyFreezeEvent

@export var _passive_event : EventResource
@export var amount : int

func execute(card_ref: Card) -> bool:
	var selected_card_pos = await GridPositionSelector.Instance.player_select_card()
	
	RiftGrid.Instance.freeze_card(selected_card_pos, _passive_event)
	
	# Ideally we would decouple this damage from the actual event itself. Unfortunately, deadlines (M2) exists.
	var defeated: bool = await RiftGrid.Instance.damage_card(selected_card_pos, amount)
	if defeated: RiftGrid.Instance.draw_card(selected_card_pos)

	#print("Selected card Position is %s "  % selected_card_pos)
	
	return true
