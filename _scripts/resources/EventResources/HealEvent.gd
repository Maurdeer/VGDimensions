extends EventResource
class_name HealEvent

@export var selection_type: SelectionEventResource.SelectionType
@export var heal_amount: int
@export var cap_at_starting_hp: bool
const selected_card_int: int = 0

func on_execute() -> bool:
	var target_card : Card = m_card_refs[selected_card_int]
	if (cap_at_starting_hp):
		target_card.hp = min(target_card.hp + heal_amount, target_card.resource.hp)
	else:
		target_card.hp += heal_amount
	return false
	
func required_events() -> Array[EventResource]:
	var selection: SelectionEventResource = SelectionEventResource.new()
	selection.store_at = selected_card_int
	selection.type = selection_type
	return [selection]
