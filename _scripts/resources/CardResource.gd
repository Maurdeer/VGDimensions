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
@export var _on_play: EventResource
@export var _on_action: ActionEvent
@export var _on_social: SocialEvent

# Passive Events
@export_group("Passive Events")
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
	
# Action Functions
func on_play(grid_pos: Vector2) -> void:
	if not _on_play: return
	_on_play.execute(grid_pos)
func on_action(grid_pos: Vector2) -> void:
	if not _on_action: return
	_on_action.execute(grid_pos)
func on_social(grid_pos: Vector2) -> void:
	if not _on_social: return
	_on_social.execute(grid_pos)

# Passive Functions
func on_enter_tree(grid_pos: Vector2) -> void:
	if not _on_enter_tree: return
	_on_enter_tree.execute(grid_pos)
func on_state_of_grid_change(grid_pos: Vector2) -> void:
	if not _on_state_of_grid_change: return
	_on_state_of_grid_change.execute(grid_pos)
func on_end_of_turn(grid_pos: Vector2) -> void:
	if not _on_end_of_turn: return
	_on_end_of_turn.execute(grid_pos)
func on_start_of_turn(grid_pos: Vector2) -> void:
	if not _on_start_of_turn: return
	_on_start_of_turn.execute(grid_pos)
func on_damage(grid_pos: Vector2) -> void:
	if not _on_damage: return
	_on_damage.execute(grid_pos)
func on_discard(grid_pos: Vector2) -> void:
	if not _on_discard: return
	_on_discard.execute(grid_pos)
func on_burn(grid_pos: Vector2) -> void:
	if not _on_burn: return
	_on_burn.exectue(grid_pos)
func on_stack(grid_pos: Vector2) -> void:
	if not _on_stack: return
	_on_stack.exectue(grid_pos)
func on_flip_hide(grid_pos: Vector2) -> void:
	if not _on_flip_hide: return
	_on_flip_hide.exectue(grid_pos)
func on_flip_reveal(grid_pos: Vector2) -> void:
	if not _on_flip_reveal: return
	_on_flip_reveal.exectue(grid_pos)
func on_move(grid_pos: Vector2) -> void:
	if not _on_move: return
	_on_move.exectue(grid_pos)
func on_replace(grid_pos: Vector2) -> void:
	if not _on_replace: return
	_on_replace.exectue(grid_pos)
