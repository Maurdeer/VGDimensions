@tool
extends Node2D
class_name Card

@export_group("Card Specifications")
# Physical Details
@export var _card_art: Texture:
	set (value):
		_card_art = value
		call_deferred("_on_card_art_change")
# Information
@export var _title: String:
	set (value):
		_title = value
		call_deferred("_on_title_change")
@export var _type: CardType:
	set (value):
		_type = value
		call_deferred("_on_card_type_change")
@export var _game_origin: GameOrigin:
	set (value):
		_game_origin = value
		call_deferred("_on_game_origin_change")
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
		call_deferred("_on_deleon_value_change")
@export var _starting_hp: int = -1:
	set (value):
		_starting_hp = value
		call_deferred("_on_starting_hp_change")

# States
@export_group("Effectors")
@export var _movable: bool = true:
	set (value):
		_movable = value
		call_deferred("_on_effector_bools_change")
@export var _burnable: bool = true:
	set (value):
		_burnable = value
		call_deferred("_on_effector_bools_change")
@export var _discardable: bool = true:
	set (value):
		_discardable = value
		call_deferred("_on_effector_bools_change")
@export var _stackable: bool = true:
	set (value):
		_stackable = value
		call_deferred("_on_effector_bools_change")

# Description Area
@export_group("Bullet Descriptions")
@export var bullets: Array[BulletResource]

# Physical Card Properities
@export_group("Physical Properities")
@export var draggable: bool = true:
	set(value):
		draggable = value
		$drag_and_drop_component2D.draggable = value
@export var playable: bool = true

# Utilities
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var bullet_scene: PackedScene

# Dynamic Stats
var hp: int
var grid_pos: Vector2
var player_owner: String # (Temp) A string for now until we change this to something more staticly defined
var revealed: bool
var on_player_hand: bool

func _enter_tree() -> void:
	revealed = true
	bullet_scene = preload("res://_scenes/card/bullet.tscn")
	refresh_stats()
	call_deferred("_setup")
	
func _setup() -> void:
	$drag_and_drop_component2D.draggable = draggable
	
func refresh_stats() -> void:
	hp = _starting_hp
	#call_deferred("_on_values_change")

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
	# Visualization Updates
	call_deferred("_on_title_change")
	call_deferred("_on_game_origin_change")
	call_deferred("_on_card_type_change")
	call_deferred("_on_card_art_change")
	call_deferred("_on_effector_bools_change")
	
	# Value TAB updates
	call_deferred("_on_starting_hp_change")
	call_deferred("_on_deleon_value_change")
	
	# Bullet Description Updates:
	call_deferred("_on_bullet_description_change")
	
func _on_title_change() -> void:
	$card_front/title_frame/Label.text = _title
	
func _on_game_origin_change() -> void:
	$card_front/typing_frame/game_origin_label.text = GameOrigin.keys()[_game_origin].capitalize()
	
func _on_card_type_change() -> void:
	$card_front/typing_frame/type_label.text = CardType.keys()[_type].capitalize()
	
func _on_card_art_change() -> void:
	$card_front/card_art_container/card_art.texture = _card_art
	
func _on_starting_hp_change() -> void:
	$card_front/HBoxContainer/health_value_frame.visible = _starting_hp >= 0
	$card_front/HBoxContainer/health_value_frame/TextureRect/Label2.text = "%s" % _starting_hp
	
func _on_deleon_value_change() -> void:
	$card_front/HBoxContainer/deleon_value_frame.visible = _deleon_value >= 0
	$card_front/HBoxContainer/deleon_value_frame/TextureRect/Label.text = "%s" % _deleon_value
		
func _on_effector_bools_change() -> void:
	pass
	
func _on_bullet_description_change() -> void:
		var bullet_list = $card_front/description_frame/bullet_list
		var child_count: int = bullet_list.get_child_count()
			
		var child_idx: int = 0
		for bullet in bullets:
			if not bullet is BulletResource: continue
			if child_idx >= child_count:
				var bullet_node = bullet_scene.instantiate()
				bullet_list.add_child(bullet_node)
				if Engine.is_editor_hint():
					bullet_node.owner = get_tree().edited_scene_root
			(bullet_list.get_child(child_idx) as Bullet).bullet_resource = bullet
			child_idx += 1
			
		# Remove extra bullet children
		for j in range(child_idx, child_count):
			bullet_list.get_child(j).queue_free()
	
func _notification(what: int) -> void:
	if what == NOTIFICATION_EDITOR_POST_SAVE:
		_on_values_change()
	
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

# Card Features
func _on_drag_and_drop_component_2d_on_double_click() -> void:
	flip()

func _on_drag_and_drop_component_2d_on_single_click() -> void:
	if not playable: return
	on_play()
