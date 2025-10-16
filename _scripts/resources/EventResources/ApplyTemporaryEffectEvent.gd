extends EventResource
class_name ApplyTemporaryEffectEvent

@export var target_card: SelectionEventResource.SelectionType
@export var temp_effect: TemporaryEffect
const target_card_at: int = 0

func on_execute() -> bool:
	# TODO: See if you need this to be a deep copy or shallow copy
	var new_effect = temp_effect.duplicate()
	m_card_refs[target_card_at].add_passive_event(new_effect)
	return false
	
func required_events() -> Array[EventResource]:
	var selection: SelectionEventResource = SelectionEventResource.new()
	selection.store_at = target_card_at
	selection.type = target_card
	return [selection]
