@abstract
extends EventResource
class_name TemporaryEffect

@export var invoked_when: PassiveEventResource.PassiveEvent

func execute(p_card_invoker: Card, p_card_refs: Dictionary[int, Card]) -> bool:
	on_duration_create()
	return super.execute(p_card_invoker, p_card_refs)

@abstract
func on_duration_create() -> void

@abstract 
func on_duration_progress() -> void

@abstract
func on_duration_remove() -> void
