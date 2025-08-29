extends Resource
class_name BulletResource

enum BulletType {
	PLAY,
	ACTION,
	DEFEAT,
	SOCIAL,
	DISCARD,
	PASSIVE
}
@export var bullet_type: BulletType
@export var bullet_cost: int

## Only used by PLAY, ACTION, and SOCIAL. For anything else refer to "Passive Events"
@export var bullet_event: EventResource
@export_multiline var bullet_description: String = ""
