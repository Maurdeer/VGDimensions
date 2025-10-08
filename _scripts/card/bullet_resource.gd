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

func try_execute(card_ref: Card) -> bool:
	# (Ryan) This is currently where cost is being spent, not sure if that is a good idea?
	if not _bullet_event: return false
	
	# Currently only action and social have a cost for bullet activativations
	match(bullet_type):
		BulletType.PLAY:
			if not await _bullet_event.execute(card_ref): return false
			await card_ref.on_play()
		BulletType.ACTION:
			if not PlayerStatistics.can_afford(PlayerStatistics.ResourceType.ACTION, bullet_cost): return false
			if not await _bullet_event.execute(card_ref): return false
			if not PlayerStatistics.purchase_attempt(PlayerStatistics.ResourceType.ACTION, bullet_cost): return false
			await card_ref.on_action()
		BulletType.SOCIAL:
			if not PlayerStatistics.can_afford(PlayerStatistics.ResourceType.SOCIAL, bullet_cost): return false
			if not await _bullet_event.execute(card_ref): return false
			if not PlayerStatistics.purchase_attempt(PlayerStatistics.ResourceType.SOCIAL, bullet_cost): return false
			await card_ref.on_social()
	return true
	
