extends Node
class_name player_statistics

#defining variables
@export var action: int
@export var social: int
@export var deleons: int
@export var attack: int
@export var tetra_city_coins: int
@export var from_nava_polaroids: int
@export var quests_completed: int


#amount is the amount we are adding or subtracting
func change_action(amount):
	action += amount

func change_social(amount):
	social += amount

func change_deleons(amount):
	deleons += amount
	
func change_attack(amount):
	attack += amount

func change_tetra_city_coins(amount):
	tetra_city_coins += amount
	
func change_from_nava_polaroids(amount):
	from_nava_polaroids += amount
	
func change_quests_completed(amount):
	quests_completed += amount
	
	
	
#boolean statistics
@export var tetra_city_coins_status: bool
@export var from_nava_polaroids_status: bool

func enable_tetra_city_coins(status):
	tetra_city_coins_status = status
	
func enable_from_nava_polaroids(status):
	from_nava_polaroids_status = status


	
