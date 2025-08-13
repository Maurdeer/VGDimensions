extends Resource
class_name Card

@export var name: String
@export var front_texture: Texture
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
	# FALL 2021
	PARAVOID,
	SIDE_BY_SIDE,
	BEAM,
	# SPRING 2022
	FACTORYTHEM,
	SLIDER,
	THRALL,
	ORB_PONDERER,
	# FALL 2022
	BLOOD_FAVOR,
	DRY,
	WILLOW, 
	BARKANE,
	# SPRING 2023
	OUTCASTS, 
	FROM_NAVA, 
	DIVE,
	# FALL 2023
	BONBON,
	CAIN,
	EPITAPH,
	EQUINOX,
	SKYLEI,
	TROLLY_PROBLEMS,
	# SPRING 2024
	BLOODELIC,
	HAMMURABI,
	QUANTUM,
	SYLVIES_CONSTELLATION, 
	TIP,
	TO_THE_FIRST_POWER,
	# FALL 2024
	ALTARUNE,
	BACK_TO_BASSICS,
	CHIME,
	HOSPITAL_DAYS,
	SHIFTSCAPE,
	TETRA_CITY,
	# SPRING 2025
	BOTTING_ALIVE,
	HADOPELAGIC,
	LIGHTBORNE,
	MOURNING_BREW,
	MURDER_MOST_FOUL,
	SLEIGHERS,
}
@export var type: CardType
@export var game_origin: GameOrigin
@export var deleon_value: int
@export var health_point: int

func _init(p_name: String = "", p_front_texture: Texture = null, p_type: CardType = CardType.FEATURE):
	name = p_name
	front_texture = p_front_texture
	type = p_type
