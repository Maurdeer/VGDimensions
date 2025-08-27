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
@export var refreshable: bool = false
@export var stunnable: bool = true
@export var flippable: bool = true

# Description Area
@export_group("Bullet Descriptions")
@export var bullets: Array[BulletResource]
@export_multiline var quip_description: String

# Visuals
@export_group("Visuals")
@export var card_art: Texture
@export var background_art: Texture # By Default base it off of the game

# Action Events
@export_group("Action Events")
@export var on_play: EventResource
@export var on_action: EventResource
@export var on_social: SocialEvent

# Passive Events
@export_group("Passive Events")
@export var on_enter_tree: EventResource
@export var on_state_of_grid_change: EventResource
@export var on_end_of_turn: EventResource
@export var on_start_of_turn: EventResource
@export var on_damage: EventResource
@export var on_discard: EventResource
@export var on_burn: EventResource
@export var on_stack: EventResource
@export var on_flip_hide: EventResource
@export var on_flip_reveal: EventResource
@export var on_move: EventResource
@export var on_replace: EventResource

# Reference to card
var card_ref: Card

func _init() -> void:
	# Action Events
	if on_play: on_play.setup(self)
	if on_action: on_action.setup(self)
	if on_social: on_social.setup(self)
	
	#Passive Events
	if on_enter_tree: on_enter_tree.setup(self)
	if on_state_of_grid_change: on_state_of_grid_change.setup(self)
	if on_end_of_turn: on_end_of_turn.setup(self)
	if on_start_of_turn: on_start_of_turn.setup(self)
	if on_damage: on_damage.setup(self)
	if on_discard: on_discard.setup(self)
	if on_burn: on_burn.setup(self)
	if on_stack: on_stack.setup(self)
	if on_flip_hide: on_flip_hide.setup(self)
	if on_flip_reveal: on_flip_reveal.setup(self)
	if on_move: on_move.setup(self)
	if on_replace: on_replace.setup(self)
