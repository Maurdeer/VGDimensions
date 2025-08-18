extends Node2D
class_name Card

# Physical Details
@export var _front_texture: Texture

# Information
@export var _type: CardType
@export var _game_origin: GameOrigin
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

# Stats
@export var _social_cost: int
@export var _deleon_value: int
@export var _starting_hp: int

# States
@export var _movable: bool = true
@export var _burnable: bool = true
@export var _discardable: bool = true
@export var _stackable: bool = true

# Utilities
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Dynamic Stats
var hp: int
var grid_pos: Vector2
var player_owner: String # (Temp) A string for now until we change this to something more staticly defined
var revealed: bool = false

func _enter_tree() -> void:
	revealed = false
	refresh_stats()
	
func refresh_stats() -> void:
	hp = _starting_hp

func damage(amount: int) -> void:
	hp -= amount
	on_damage()

func flip() -> void:
	if revealed: flip_hide()
	else: flip_reveal()

func flip_reveal() -> void:
	animation_player.play("flip_reveal")
	revealed = true
	on_flip_reveal()

func flip_hide() -> void:
	animation_player.play("flip_hide")
	revealed = false
	on_flip_hide()
	


# Overridable Functions
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
func on_play() -> void:
	pass


func _on_drag_and_drop_component_2d_on_double_click() -> void:
	flip()
