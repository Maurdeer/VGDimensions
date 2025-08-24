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
@export_multiline var bullet_description: String = ""
