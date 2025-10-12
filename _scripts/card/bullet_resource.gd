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
@export var _bullet_events: Array[EventResource]
@export_multiline var bullet_description: String = ""

func try_execute(card_invoker: Card) -> bool:
	# (Ryan) This is currently where cost is being spent, not sure if that is a good idea?
	if _bullet_events.is_empty(): return false
	
	# Currently only action and social have a cost for bullet activativations
	match(bullet_type):
		BulletType.PLAY:
			queue_bullet_events.rpc(card_invoker.card_id)
			if queue_bullet_events(card_invoker.card_id): return false
		BulletType.ACTION:
			if not PlayerStatistics.can_afford(PlayerStatistics.ResourceType.ACTION, bullet_cost): return false
			queue_bullet_events.rpc(card_invoker.card_id)
			if queue_bullet_events(card_invoker.card_id): return false
			if not PlayerStatistics.purchase_attempt(PlayerStatistics.ResourceType.ACTION, bullet_cost): return false
		BulletType.SOCIAL:
			if not PlayerStatistics.can_afford(PlayerStatistics.ResourceType.SOCIAL, bullet_cost): return false
			queue_bullet_events.rpc(card_invoker.card_id)
			if queue_bullet_events(card_invoker.card_id): return false
			if not PlayerStatistics.purchase_attempt(PlayerStatistics.ResourceType.SOCIAL, bullet_cost): return false
	return true
	
@rpc("call_remote", "any_peer", "reliable")
func queue_bullet_events(cid: int) -> bool:
	var card_invoker: Card = CardManager.get_card_by_id(cid)
	EventManager.queue_event_group(_bullet_events, card_invoker)
	# Process here to see what happens
	if EventManager.process_event_queue():
		return true
	match(bullet_type):
		BulletType.PLAY:
			card_invoker.on_play()
		BulletType.ACTION:
			card_invoker.on_action()
		BulletType.SOCIAL:
			card_invoker.on_social()
	EventManager.process_event_queue()
	return false
