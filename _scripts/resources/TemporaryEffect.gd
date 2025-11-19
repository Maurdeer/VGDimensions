@tool
@abstract
extends EventResource
class_name TemporaryEffect

@export var is_global: bool:
	set(value):
		is_global = value
		if is_global: invoked_when = global_event
		else: invoked_when = local_event
		notify_property_list_changed()
var invoked_when
@export var global_event: PassiveEventResource.GlobalEvent = PassiveEventResource.GlobalEvent.ON_CARD_PLAY:
	set(value):
		if is_global: invoked_when = value
		global_event = value
@export var local_event: PassiveEventResource.PassiveEvent:
	set(value):
		if not is_global: invoked_when = value
		local_event = value
@export var duration: int = 2
var curr_duration: int

func on_effect_apply() -> void:
	curr_duration = duration
	
func on_effect_progress() -> void:
	curr_duration -= 1
	if curr_duration <= 0:
		on_effect_finish()
	
func on_effect_finish() -> void:
	m_card_invoker.remove_passive_event(self)

func _validate_property(property: Dictionary) -> void:
	var hide_list = []
	
	if is_global:
		hide_list.append("local_event")
	else:
		hide_list.append("global_event")
		
	if property.name in hide_list:
		property.usage = PROPERTY_USAGE_NO_EDITOR
