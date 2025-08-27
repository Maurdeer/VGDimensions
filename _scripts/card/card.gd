extends Node2D
class_name Card

@export var resource: CardResource

# Physical Card Properities
@export_group("Physical Properities")
@export var draggable: bool = true:
	set(value):
		draggable = value
		$drag_and_drop_component2D.draggable = value
@export var playable: bool = true

# Utilities
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Dynamic Stats
var hp: int
var grid_pos: Vector2
var player_owner: String # (Temp) A string for now until we change this to something more staticly defined
var revealed: bool
var on_player_hand: bool

func _enter_tree() -> void:
	resource.card_ref = self
	revealed = true
	refresh_stats()
	call_deferred("_setup")
	
func _setup() -> void:
	$drag_and_drop_component2D.draggable = draggable
	
func refresh_stats() -> void:
	hp = resource.starting_hp
	#call_deferred("_on_values_change")

func damage(amount: int) -> void:
	hp -= amount
	resource.on_damage()

func flip() -> void:
	if revealed: flip_hide()
	else: flip_reveal()

func flip_reveal() -> void:
	animation_player.play("flip_reveal")
	revealed = true
	if resource.on_flip_reveal: resource.on_flip_reveal()

func flip_hide() -> void:
	animation_player.play("flip_hide")
	revealed = false
	if resource.on_flip_hide: resource.on_flip_hide()
	
func play() -> void:
	resource.on_play()

# Card Input Functions
func _on_drag_and_drop_component_2d_on_double_click() -> void:
	flip()

func _on_drag_and_drop_component_2d_on_single_click() -> void:
	if not playable: return
	play()
