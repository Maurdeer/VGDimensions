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

## Only used by PLAY, ACTION, and SOCIAL. For anything else refer to "Passive Events"
@export var bullet_event: EventResource
@export var passive_events: Array[PassiveEventResource]
@export_multiline var bullet_description: String = ""

func _validate_property(property: Dictionary) -> void:
	var hide_list = []
	match bullet_type:
		BulletType.PLAY:
			hide_list.append("passive_events")
			hide_list.append("bullet_cost")
		BulletType.ACTION:
			hide_list.append("passive_events")
		BulletType.SOCIAL:
			hide_list.append("passive_events")
		_:
			hide_list.append("bullet_event")
			hide_list.append("bullet_cost")
	if property.name in hide_list:
		property.usage = PROPERTY_USAGE_NO_EDITOR
