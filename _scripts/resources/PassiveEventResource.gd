@tool
extends Resource
class_name PassiveEventResource

enum PassiveEvent {
	ON_PLAY = 0,
	ON_ACTION,
	ON_SOCIAL,
	ON_ENTER_TREE,
	ON_DAMAGE,
	ON_DISCARD,
	ON_BURN,
	ON_STACK,
	ON_FLIP_HIDE,
	ON_FLIP_REVEAL,
	ON_BEFORE_MOVE,
	ON_AFTER_MOVE,
	ON_REPLACE,
	ON_FREEZE
}
enum GlobalEvent {
	ON_CARD_PLAY = 15,
	ON_CARD_ACTION,
	ON_CARD_SOCIAL,
	ON_STATE_OF_GRID_CHANGE,
	ON_START_OF_TURN,
	ON_END_OF_TURN,
	ON_CARD_DAMAGE,
	ON_CARD_DISCARD,
	ON_CARD_BURN,
	ON_CARD_STACK,
	ON_CARD_BEFORE_MOVE,
	ON_CARD_AFTER_MOVE,
	ON_CARD_REPLACE,
	ON_CARD_FREEZE,
	ON_QUEST_PROGRESS
}
@export var is_global: bool:
	set(value):
		is_global = value
		notify_property_list_changed()
@export var passive_event_type: PassiveEvent
@export var global_event_type: GlobalEvent = GlobalEvent.ON_CARD_PLAY
@export var event: EventResource

static var LOCAL_ENUM_HINT := ",".join(PassiveEvent.keys())
static var GLOBAL_ENUM_HINT := ",".join(GlobalEvent.keys())

func _validate_property(property: Dictionary) -> void:
	var hide_list = []
	if is_global:
		hide_list.append("passive_event_type")
	else:
		hide_list.append("global_event_type")
	if property.name in hide_list:
		property.usage = PROPERTY_USAGE_NO_EDITOR
