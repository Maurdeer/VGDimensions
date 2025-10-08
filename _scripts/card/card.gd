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
		
var grid_pos: Vector2i = Vector2i(-1, -1)
var deck_pos: int = -1
var player_owner: String # (Temp) A string for now until we change this to something more staticly defined
var revealed: bool
var temporary: bool = false
var interactable: bool = false:
	set(value):
		dnd_2d.interactable = value
		interactable = value
		
var card_id: int

# Dynamic Bullet Functions
var _play_bullets: Array[BulletResource]
var _action_bullets: Array[BulletResource]
var _social_bullets: Array[BulletResource]

func set_up(p_card_id: int, p_resource: CardResource) -> void:
	card_id = p_card_id
	resource = p_resource

func _enter_tree() -> void:
	#refresh_stats()
	on_enter_tree()
	call_deferred("_setup")
	
func _setup() -> void:
	# Play the animation when entering the tree
	if not revealed: animation_player.play("flip_hide")
	else: animation_player.play("flip_reveal")
	
	# Let card be draggable on launch or not
	dnd_2d.draggable = draggable
	
func _on_resource_change() -> void:
	for bullet in resource.bullets:
		match(bullet.bullet_type):
			BulletResource.BulletType.PLAY:
				_play_bullets.append(bullet)
			BulletResource.BulletType.ACTION:
				_action_bullets.append(bullet)
			BulletResource.BulletType.SOCIAL:
				_social_bullets.append(bullet)
				
	resource.set_up_event_resources()
	
func refresh_stats() -> void:
	hp = resource.starting_hp
	#call_deferred("_on_values_change")

# Return whether or not the card reach zero hp
func damage(amount: int) -> bool:
	hp -= amount
	on_damage()
	if hp < 0: hp = 0
	return hp == 0

func flip() -> void:
	if revealed: flip_hide()
	else: flip_reveal()

func flip_reveal() -> void:
	if revealed: return
	if is_visible_in_tree(): 
		animation_player.play("flip_reveal")
		on_flip_reveal() # (Ryan) May want to remove, this is kinda not good
	revealed = true

func flip_hide() -> void:
	if not revealed: return
	if is_visible_in_tree(): 
		animation_player.play("flip_hide")
		on_flip_hide() # (Ryan) May want to remove, this is kinda not good
	revealed = false

# Card Input Functions
func _on_double_click() -> void:
	pass
	#flip()

func _on_single_click() -> void:
	#if CardInspector.Instance: CardInspector.Instance.set_card(self)
	card_sm.clicked_on()

var _pressed_previously: bool = false
func _on_drag_and_drop_component_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if not interactable or not event is InputEventMouseButton: return
	var mouse_button_event: InputEventMouseButton = event
	if mouse_button_event.button_index == MOUSE_BUTTON_LEFT:
		if mouse_button_event.pressed and not _pressed_previously:
			_pressed_previously = true
			if mouse_button_event.double_click:
				_on_double_click()
			else:
				_on_single_click()
		_pressed_previously = mouse_button_event.pressed
				
func _on_drag_and_drop_component_2d_on_drop() -> void:
	pass # Replace with function body.
	
# Passive Functions
func on_play(): for event in resource.passive_events[PassiveEventResource.PassiveEvent.ON_PLAY]: await event.execute(self)
func on_action(): for event in resource.passive_events[PassiveEventResource.PassiveEvent.ON_ACTION]: await event.execute(self)
func on_social(): for event in resource.passive_events[PassiveEventResource.PassiveEvent.ON_SOCIAL]: await event.execute(self)
func on_enter_tree(): for event in resource.passive_events[PassiveEventResource.PassiveEvent.ON_ENTER_TREE]: await event.execute(self)
func on_state_of_grid_change(): for event in resource.passive_events[PassiveEventResource.PassiveEvent.ON_STATE_OF_GRID_CHANGE]: await event.execute(self)
func on_end_of_turn(): for event in resource.passive_events[PassiveEventResource.PassiveEvent.ON_END_OF_TURN]: await event.execute(self)
func on_start_of_turn(): for event in resource.passive_events[PassiveEventResource.PassiveEvent.ON_START_OF_TURN]: await event.execute(self)
func on_damage(): for event in resource.passive_events[PassiveEventResource.PassiveEvent.ON_DAMAGE]: await event.execute(self)
func on_discard(): for event in resource.passive_events[PassiveEventResource.PassiveEvent.ON_DISCARD]: await event.execute(self)
func on_burn(): for event in resource.passive_events[PassiveEventResource.PassiveEvent.ON_BURN]: await event.execute(self)
func on_stack(): for event in resource.passive_events[PassiveEventResource.PassiveEvent.ON_STACK]: await event.execute(self)
func on_flip_hide(): for event in resource.passive_events[PassiveEventResource.PassiveEvent.ON_FLIP_HIDE]: await event.execute(self)
func on_flip_reveal(): for event in resource.passive_events[PassiveEventResource.PassiveEvent.ON_FLIP_REVEAL]: await event.execute(self)
func on_before_move(): for event in resource.passive_events[PassiveEventResource.PassiveEvent.ON_BEFORE_MOVE]: await event.execute(self)
func on_after_move(): for event in resource.passive_events[PassiveEventResource.PassiveEvent.ON_AFTER_MOVE]: await event.execute(self)
func on_replace(): for event in resource.passive_events[PassiveEventResource.PassiveEvent.ON_REPLACE]: await event.execute(self)
func on_freeze(): for event in resource.passive_events[PassiveEventResource.PassiveEvent.ON_FREEZE]: await event.execute(self)
