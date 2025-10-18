@abstract
extends EventResource
class_name TemporaryEffect

@export var invoked_when: PassiveEventResource.PassiveEvent
@export var duration: int = 2
var curr_duration: int

func on_duration_create() -> void:
	curr_duration = duration
	
func on_duration_progress() -> void:
	curr_duration -= 1
	if curr_duration <= 0:
		on_duration_remove()
	
func on_duration_remove() -> void:
	m_card_invoker.remove_passive_event(self)
