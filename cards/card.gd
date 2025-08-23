@tool
extends Node2D
class_name Card

@export_group("Card Specifications")
# Physical Details
@export var _card_art: Texture:
	set (value):
		_card_art = value
		call_deferred("_on_values_change")
# Information
@export var _title: String:
	set (value):
		_title = value
		call_deferred("_on_values_change")
@export var _type: CardType:
	set (value):
		_type = value
		call_deferred("_on_values_change")
@export var _game_origin: GameOrigin:
	set (value):
		_game_origin = value
		call_deferred("_on_values_change")
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
@export var _deleon_value: int = -1:
	set (value):
		_deleon_value = value
		call_deferred("_on_values_change")
@export var _starting_hp: int = -1:
	set (value):
		_starting_hp = value
		call_deferred("_on_values_change")

# States
@export_group("Effectors")
@export var _movable: bool = true:
	set (value):
		_movable = value
		call_deferred("_on_values_change")
@export var _burnable: bool = true:
	set (value):
		_burnable = value
		call_deferred("_on_values_change")
@export var _discardable: bool = true:
	set (value):
		_discardable = value
		call_deferred("_on_values_change")
@export var _stackable: bool = true:
	set (value):
		_stackable = value
		call_deferred("_on_values_change")

# Description Area
enum BulletType {
	PLAY,
	ACTION,
	DEFEAT,
	SOCIAL,
	DISCARD,
	PASSIVE
}
var _bullet_type: BulletType
var _bullet_description: String = ""


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
	
# Tool Related
func _on_values_change() -> void:
	$card_front/title_frame/Label.text = _title
	$card_front/typing_frame/game_origin_label.text = GameOrigin.keys()[_game_origin].capitalize()
	$card_front/typing_frame/type_label.text = CardType.keys()[_type].capitalize()
	$card_front/card_art_container/card_art.texture = _card_art
	
	$card_front/HBoxContainer/deleon_value_frame.visible = _deleon_value >= 0
	$card_front/HBoxContainer/deleon_value_frame/TextureRect/Label.text = "%s" % _deleon_value
	$card_front/HBoxContainer/health_value_frame.visible = _starting_hp >= 0
	$card_front/HBoxContainer/health_value_frame/TextureRect/Label2.text = "%s" % _starting_hp
	
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

# Extra
func _on_drag_and_drop_component_2d_on_double_click() -> void:
	flip()
	
func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	properties.append({
		"name" : "Bullet Category",
		"type": TYPE_NIL,
		"usage": PROPERTY_USAGE_GROUP,
	})
	properties.append({
		"name" : "_create_new_bullet_subgroup",
		"type" : TYPE_CALLABLE,
		"usage" : PROPERTY_USAGE_EDITOR,
		"hint" : PROPERTY_HINT_TOOL_BUTTON,
	})
	return properties
	
func _create_new_bullet_subgroup() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	properties.append({
		"name" : "_bullet_type",
		"type": BulletType,
		"usage": PROPERTY_USAGE_DEFAULT,
	})
	properties.append({
		"name" : "_bullet_description",
		"type": TYPE_STRING,
		"usage": PROPERTY_USAGE_DEFAULT,
		"hint": PROPERTY_HINT_MULTILINE_TEXT
	})
	return properties
