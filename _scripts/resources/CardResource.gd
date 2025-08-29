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

# Passive Events
@export_group("Passive Events")
@export var _on_play: EventResource
@export var _on_action: EventResource
@export var _on_social: EventResource
@export var _on_enter_tree: EventResource
@export var _on_state_of_grid_change: EventResource
@export var _on_end_of_turn: EventResource
@export var _on_start_of_turn: EventResource
@export var _on_damage: EventResource
@export var _on_discard: EventResource
@export var _on_burn: EventResource
@export var _on_stack: EventResource
@export var _on_flip_hide: EventResource
@export var _on_flip_reveal: EventResource
@export var _on_move: EventResource
@export var _on_replace: EventResource
	
func set_up_event_resources(card_ref: Card):
	if _on_play: _on_play.card_ref = card_ref
	if _on_action: _on_action.card_ref = card_ref
	if _on_social: _on_social.card_ref = card_ref
	if _on_enter_tree: _on_enter_tree.card_ref = card_ref
	if _on_state_of_grid_change: _on_state_of_grid_change.card_ref = card_ref
	if _on_end_of_turn: _on_end_of_turn.card_ref = card_ref
	if _on_start_of_turn: _on_start_of_turn.card_ref = card_ref
	if _on_damage: _on_damage.card_ref = card_ref
	if _on_discard: _on_discard.card_ref = card_ref 
	if _on_burn: _on_burn.card_ref = card_ref
	if _on_stack: _on_stack.card_ref = card_ref
	if _on_flip_hide: _on_flip_hide.card_ref = card_ref
	if _on_flip_reveal: _on_flip_reveal.card_ref = card_ref
	if _on_move: _on_move.card_ref = card_ref 
	if _on_replace: _on_replace.card_ref = card_ref
	
# Passive Functions
func on_play() -> void:
	if not _on_play: return
	_on_play.execute()
func on_action() -> void:
	if not _on_action: return
	_on_action.execute()
func on_social() -> void:
	if not _on_social: return
	_on_social.execute()
func on_enter_tree() -> void:
	if not _on_enter_tree: return
	_on_enter_tree.execute()
func on_state_of_grid_change() -> void:
	if not _on_state_of_grid_change: return
	_on_state_of_grid_change.execute()
func on_end_of_turn() -> void:
	if not _on_end_of_turn: return
	_on_end_of_turn.execute()
func on_start_of_turn() -> void:
	if not _on_start_of_turn: return
	_on_start_of_turn.execute()
func on_damage() -> void:
	if not _on_damage: return
	_on_damage.execute()
func on_discard() -> void:
	if not _on_discard: return
	_on_discard.execute()
func on_burn() -> void:
	if not _on_burn: return
	_on_burn.exectue()
func on_stack() -> void:
	if not _on_stack: return
	_on_stack.exectue()
func on_flip_hide() -> void:
	if not _on_flip_hide: return
	_on_flip_hide.exectue()
func on_flip_reveal() -> void:
	if not _on_flip_reveal: return
	_on_flip_reveal.exectue()
func on_move() -> void:
	if not _on_move: return
	_on_move.exectue()
func on_replace() -> void:
	if not _on_replace: return
	_on_replace.exectue()
