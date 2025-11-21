extends Node

#defining variables
signal on_stats_change
signal on_resource_spend_fail(ResourceType)
signal on_resource_spend_success(ResourceType)

@export var actions: int:
	set(value):
		actions = value
		on_stats_change.emit()
@export var socials: int:
	set(value):
		socials = value
		on_stats_change.emit()
@export var deleons: int:
	set(value):
		deleons = value
		on_stats_change.emit()
@export var attack: int:
	set(value):
		attack = value
		on_stats_change.emit()
@export var tetra_city_coins: int:
	set(value):
		tetra_city_coins = value
		on_stats_change.emit()
@export var from_nava_polaroids: int:
	set(value):
		from_nava_polaroids = value
		on_stats_change.emit()
@export var quests_completed: int:
	set(value):
		quests_completed = value
		on_stats_change.emit()
@export var dimensions_won: int:
	set(value):
		dimensions_won = value
		on_stats_change.emit()
@export var sleighers_cheer: int:
	set(value):
		sleighers_cheer = value
		on_stats_change.emit()

#For Sleighers implementation, remember to set this correctly
@export var sleighers_team =  SleighersTeam.FAE
		
func modify_resource(type: ResourceType, amount: int) -> void:
	match(type):
		ResourceType.DELEON:
			deleons += amount
		ResourceType.ACTION:
			actions += amount
		ResourceType.SOCIAL:
			socials += amount
		ResourceType.POLAROID:
			from_nava_polaroids += amount
		ResourceType.TETRACOIN:
			tetra_city_coins += amount
		ResourceType.CHEER:
			if sleighers_team == team:
				sleighers_cheer += amount


func can_afford(type: ResourceType, required_amount: int) -> bool:
	var affordable = false
	match(type):
		ResourceType.DELEON:
			affordable = deleons >= required_amount
		ResourceType.ACTION:
			affordable = actions >= required_amount
		ResourceType.SOCIAL:
			affordable = socials >= required_amount
		ResourceType.TETRACOIN:
			affordable = tetra_city_coins >= required_amount
			
	if not affordable:
		on_resource_spend_fail.emit(type)
		
	return affordable
			
func purchase_attempt(type: ResourceType, required_amount: int) -> bool:
	var success = false
	match(type):
		ResourceType.DELEON:
			if deleons >= required_amount:
				success = true
				deleons -= required_amount
		ResourceType.ACTION:
			if actions >= required_amount:
				success = true
				actions -= required_amount
		ResourceType.SOCIAL:
			if socials >= required_amount:
				success = true
				socials -= required_amount
		ResourceType.TETRACOIN:
			if tetra_city_coins >= required_amount:
				success = true
				tetra_city_coins -= required_amount
			
	if success:
		on_resource_spend_success.emit(type)
	else:
		on_resource_spend_fail.emit(type)
		
	return success
	
#boolean statistics
@export var tetra_city_coins_status: bool
@export var from_nava_polaroids_status: bool
@export var sleighers_cheer_status: bool

func enable_sleighers_cheer(status):
	sleighers_cheer_status = status

func enable_tetra_city_coins(status):
	tetra_city_coins_status = status
	
func enable_from_nava_polaroids(status):
	from_nava_polaroids_status = status

enum ResourceType {
	DELEON,
	ACTION,
	SOCIAL,
	POLAROID,
	TETRACOIN,
	CHEER
}

enum SleighersTeam {
	FAE,
	FIR,
	NEUTRAL
}
