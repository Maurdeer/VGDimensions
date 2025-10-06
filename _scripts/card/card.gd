extends Node2D
class_name Card

# Change these signals to include the card parameter that is pushed into it.
@warning_ignore("unused_signal")
signal played(Card)
@warning_ignore("unused_signal")
signal interacted(Card)
@warning_ignore("unused_signal")
signal selected(Vector2i)

signal on_stats_change

@export var resource: CardResource:
	set(value):
		resource = value
		_on_resource_change()
	get:
		if not resource:
			resource = CardResource.new()
			_on_resource_change()
		return resource

# Physical Card Properities
@export_group("Physical Properities")
@export var draggable: bool = false:
	set(value):
		draggable = value
		$drag_and_drop_component2D.draggable = value

const SELECTION_UI = preload("uid://vei3yr63fqcj")

# Utilities
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var card_sm: CardStateMachine = $CardSM
@onready var dnd_2d: DragAndDropComponent2D = $drag_and_drop_component2D

# Dynamic Stats
var hp: int:
	set(value):
		hp = value
		on_stats_change.emit()
		
var grid_pos: Vector2i
var player_owner: String # (Temp) A string for now until we change this to something more staticly defined
var revealed: bool
var on_player_hand: bool
var card_id: String:
	get:
		if not resource: return ""
		return construct_card_id(resource.title, resource.game_origin)

# Dynamic Bullet Functions
var _play_bullets: Array[BulletResource]
var _action_bullets: Array[BulletResource]
var _social_bullets: Array[BulletResource]

func _enter_tree() -> void:
	refresh_stats()
	call_deferred("_setup")
	
func _setup() -> void:
	# Play the animation when entering the tree
	if not revealed: animation_player.play("flip_hide")
	else: animation_player.play("flip_reveal")
	
	# Let card be draggable on launch or not
	dnd_2d.draggable = draggable
	
func _on_resource_change() -> void:
	for bullet in resource.bullets:
		bullet.set_event_card_ref(self)
		match(bullet.bullet_type):
			BulletResource.BulletType.PLAY:
				_play_bullets.append(bullet)
			BulletResource.BulletType.ACTION:
				_action_bullets.append(bullet)
			BulletResource.BulletType.SOCIAL:
				_social_bullets.append(bullet)
				
	resource.set_up_event_resources(self)
	
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
	if revealed: return
	if is_visible_in_tree(): 
		animation_player.play("flip_reveal")
		resource.on_flip_reveal() # (Ryan) May want to remove, this is kinda not good
	revealed = true

func flip_hide() -> void:
	if not revealed: return
	if is_visible_in_tree(): 
		animation_player.play("flip_hide")
		resource.on_flip_hide() # (Ryan) May want to remove, this is kinda not good
	revealed = false

# Card Input Functions
func _on_double_click() -> void:
	pass
	#flip()

func _on_single_click() -> void:
	if CardInspector.Instance: CardInspector.Instance.set_card(self)
	card_sm.clicked_on()

func _on_drag_and_drop_component_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if not event is InputEventMouseButton: return
	var mouse_button_event: InputEventMouseButton = event
	if mouse_button_event.button_index == MOUSE_BUTTON_LEFT:
		if mouse_button_event.pressed:
			if mouse_button_event.double_click:
				_on_double_click()
			else:
				_on_single_click()
				
func _on_drag_and_drop_component_2d_on_drop() -> void:
	pass # Replace with function body.

static func construct_card_id(title: String, game_origin: CardResource.GameOrigin) -> String:
	return "%s-%s" % [title, CardResource.GameOrigin.keys()[game_origin]]
