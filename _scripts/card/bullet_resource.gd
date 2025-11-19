@tool
extends Resource
class_name BulletResource

enum BulletType {
	PLAY,
	ACTION,
	SOCIAL,
	PASSIVE
}
@export var bullet_type: BulletType:
	set(value):
		bullet_type = value
		notify_property_list_changed()
@export var bullet_cost: int = 1


@export var is_multi_event: bool:
	set(value):
		is_multi_event = value
		notify_property_list_changed()
## Only used by PLAY, ACTION, and SOCIAL. For anything else refer to "Passive Events"
@export var bullet_event: EventResource:
	set(value):
		if bullet_events.is_empty():
			bullet_events.append(value)
		else:
			bullet_events[0] = value
		bullet_event = value
@export var bullet_events: Array[EventResource]:
	set(value):
		if value.is_empty():
			bullet_event = null
		else:
			bullet_event = value[0]
		bullet_events = value
@export var passive_event: PassiveEventResource:
	set(value):
		if passive_events.is_empty():
			passive_events.append(value)
		else:
			passive_events[0] = value
		passive_event = value
@export var passive_events: Array[PassiveEventResource]:
	set(value):
		if value.is_empty():
			passive_event = null
		else:
			passive_event = value[0]
		passive_events = value

@export_multiline var bullet_description: String = ""

func _validate_property(property: Dictionary) -> void:
	var hide_list = []
	
	var event_type_to_hide = ""
	var event_type_to_use = ""
	
	if bullet_type == BulletType.PASSIVE:
		event_type_to_hide = "bullet"
		event_type_to_use = "passive"
		hide_list.append("bullet_cost")
	else:
		event_type_to_hide ="passive"
		event_type_to_use = "bullet"
		if bullet_type == BulletType.PLAY: hide_list.append("bullet_cost")
		
	hide_list.append("%s_event" % event_type_to_hide)
	hide_list.append("%s_events" % event_type_to_hide)
	
	if is_multi_event:
		hide_list.append("%s_event" % event_type_to_use)
	else:
		hide_list.append("%s_events" % event_type_to_use)
		
	if property.name in hide_list:
		property.usage = PROPERTY_USAGE_NO_EDITOR
