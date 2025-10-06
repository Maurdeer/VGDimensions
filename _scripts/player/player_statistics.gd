extends Node

#defining variables
signal on_stats_change

@export var actions: int
@export var socials: int
@export var deleons: int
@export var attack: int
@export var tetra_city_coins: int
@export var from_nava_polaroids: int
@export var quests_completed: int


#amount is the amount we are adding or subtracting
func modify_base_resource(type: ResourceType, amount: int):
	match (type):
		ResourceType.DELEON:
			deleons += amount
		ResourceType.ACTION:
			actions += amount
		ResourceType.SOCIAL:
			socials += amount
			
	on_stats_change.emit()
	
func replace_base_resource(type: ResourceType, value: int):
	match (type):
		ResourceType.DELEON:
			deleons = value
		ResourceType.ACTION:
			actions = value
		ResourceType.SOCIAL:
			socials = value
			
	on_stats_change.emit()
	
func change_attack(amount):
	attack += amount
	on_stats_change.emit()

func change_tetra_city_coins(amount):
	tetra_city_coins += amount
	on_stats_change.emit()
	
func change_from_nava_polaroids(amount):
	from_nava_polaroids += amount
	on_stats_change.emit()
	
func change_quests_completed(amount):
	quests_completed += amount
	on_stats_change.emit()
	
#boolean statistics
@export var tetra_city_coins_status: bool
@export var from_nava_polaroids_status: bool

func enable_tetra_city_coins(status):
	tetra_city_coins_status = status
	
func enable_from_nava_polaroids(status):
	from_nava_polaroids_status = status

enum ResourceType {
	DELEON,
	ACTION,
	SOCIAL
}
