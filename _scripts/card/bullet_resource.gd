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
@export var _bullet_event: EventResource
@export_multiline var bullet_description: String = ""

func try_execute() -> void:
	# (Ryan) This is currently where cost is being spent, not sure if that is a good idea?
	if not _bullet_event: return
	
	# Currently only action and social have a cost for bullet activativations
	if bullet_type == BulletType.ACTION:
		if PlayerStatistics.actions < bullet_cost: return
		PlayerStatistics.modify_base_resource(PlayerStatistics.ResourceType.ACTION, -bullet_cost)
	if bullet_type == BulletType.SOCIAL:
		if PlayerStatistics.socials < bullet_cost: return
		PlayerStatistics.modify_base_resource(PlayerStatistics.ResourceType.SOCIAL, -bullet_cost)
	
	_bullet_event.execute()
func set_event_card_ref(card: Card) -> void:
	if not _bullet_event: return
	_bullet_event.card_ref = card
