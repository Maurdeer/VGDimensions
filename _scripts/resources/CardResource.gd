extends Resource
class_name CardResource

@export_group("Card Specifications")
# Information
@export var title: String
@export var type: CardType
@export var game_origin: GameOrigin
enum CardType {
	FEATURE, 
	ASSET, 
	LOCATION, 
	QUEST, 
	STRUCTURE, 
	TERRAIN, 
	CHARACTER, 
	ENEMY
}
enum GameOrigin {
	VGDEV, 

	# SPRING 2025
	BOTTING_ALIVE,
	HADOPELAGIC,
	LIGHTBORNE,
	MOURNING_BREW,
	MURDER_MOST_FOUL,
	SLEIGHERS,
	
	# FALL 2024
	ALTARUNE,
	BACK_TO_BASSICS,
	CHIME,
	HOSPITAL_DAYS,
	SHIFTSCAPE,
	TETRA_CITY,
	
	# SPRING 2024
	BLOODELIC,
	HAMMURABI,
	QUANTUM,
	SYLVIES_CONSTELLATION, 
	TIP,
	TO_THE_FIRST_POWER,
	
	# FALL 2023
	BONBON,
	CAIN,
	EPITAPH,
	EQUINOX,
	SKYLEI,
	TROLLY_PROBLEMS,
	
	# SPRING 2023
	OUTCASTS, 
	FROM_NAVA, 
	DIVE,
	
	# FALL 2022
	BLOOD_FAVOR,
	DRY,
	WILLOW, 
	BARKANE,
	
	# SPRING 2022
	FACTORYTHEM,
	SLIDER,
	THRALL,
	ORB_PONDERER,
	
	# FALL 2021
	PARAVOID,
	SIDE_BY_SIDE,
	BEAM,
}

# Stats
@export_group("Stats")
@export var deleon_value: int = -1
@export var starting_hp: int = -1

# States
@export_group("Effectors")
@export var movable: bool = true
@export var burnable: bool = true
@export var discardable: bool = true
@export var stackable: bool = true

# Description Area
@export_group("Bullet Descriptions")
@export var bullets: Array[BulletResource]

# Visuals
@export_group("Visuals")
@export var card_art: Texture
@export var background_art: Texture # By Default base it off of the game

# Reference to card
var card: Card
var on_play_functions: Array[Callable]
var on_action_functions: Array[Callable]
var on_socialize_functions: Array[Callable]

# Overridable Functions
func on_enter_tree() -> void:
	pass
func on_state_of_grid_change() -> void:
	pass
func on_end_of_turn() -> void:
	pass
func on_start_of_turn() -> void:
	pass
func on_damage() -> void:
	pass
func on_discard() -> void:
	pass
func on_burn() -> void:
	pass
func on_stack() -> void:
	pass
func on_flip_hide() -> void:
	pass
func on_flip_reveal() -> void:
	pass
func on_move() -> void:
	pass
func on_replace() -> void:
	pass
