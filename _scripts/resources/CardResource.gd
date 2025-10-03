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
@export var description_textures: Array[Texture]
@export_multiline var quip_description: String

# Passive Events
@export_group("Passive Events")
@export var _passive_events: Array[PassiveEventResource]
var _events: Array[Array]

# Visuals
@export_group("Visuals")
@export var card_art: Texture
@export var background_art: Texture # By Default base it off of the game

	
func set_up_event_resources(card_ref: Card):
	_events.clear()
	_events.resize(PassiveEventResource.PassiveEvent.size())
	for passive_event in _passive_events:
		passive_event.event.card_ref = card_ref
		_events[passive_event.event_type].append(passive_event.event)
	
# Passive Functions
func on_play(): for event in _events[PassiveEventResource.PassiveEvent.ON_PLAY]: event.execute()
func on_action(): for event in _events[PassiveEventResource.PassiveEvent.ON_ACTION]: event.execute()
func on_social(): for event in _events[PassiveEventResource.PassiveEvent.ON_SOCIAL]: event.execute()
func on_enter_tree(): for event in _events[PassiveEventResource.PassiveEvent.ON_ENTER_TREE]: event.execute()
func on_state_of_grid_change(): for event in _events[PassiveEventResource.PassiveEvent.ON_STATE_OF_GRID_CHANGE]: event.execute()
func on_end_of_turn(): for event in _events[PassiveEventResource.PassiveEvent.ON_END_OF_TURN]: event.execute()
func on_start_of_turn(): for event in _events[PassiveEventResource.PassiveEvent.ON_START_OF_TURN]: event.execute()
func on_damage(): for event in _events[PassiveEventResource.PassiveEvent.ON_DAMAGE]: event.execute()
func on_discard(): for event in _events[PassiveEventResource.PassiveEvent.ON_DISCARD]: event.execute()
func on_burn(): for event in _events[PassiveEventResource.PassiveEvent.ON_BURN]: event.execute()
func on_stack(): for event in _events[PassiveEventResource.PassiveEvent.ON_STACK]: event.execute()
func on_flip_hide(): for event in _events[PassiveEventResource.PassiveEvent.ON_FLIP_HIDE]: event.execute()
func on_flip_reveal(): for event in _events[PassiveEventResource.PassiveEvent.ON_FLIP_REVEAL]: event.execute()
func on_move(): for event in _events[PassiveEventResource.PassiveEvent.ON_MOVE]: event.execute()
func on_replace(): for event in _events[PassiveEventResource.PassiveEvent.ON_REPLACE]: event.execute()
