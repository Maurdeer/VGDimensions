extends Resource
class_name PassiveEventResource

enum PassiveEvent {
	ON_PLAY,
	ON_ACTION,
	ON_SOCIAL,
	ON_ENTER_TREE,
	ON_STATE_OF_GRID_CHANGE,
	ON_END_OF_TURN,
	ON_START_OF_TURN,
	ON_DAMAGE,
	ON_DISCARD,
	ON_BURN,
	ON_STACK,
	ON_FLIP_HIDE,
	ON_FLIP_REVEAL,
	ON_MOVE,
	ON_REPLACE,
}
@export var event_type: PassiveEvent
@export var event: EventResource
