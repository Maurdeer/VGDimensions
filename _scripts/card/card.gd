extends Node2D
class_name Card

# Change these signals to include the card parameter that is pushed into it.
@warning_ignore("unused_signal")
signal played(Card)
@warning_ignore("unused_signal")
signal interacted(Card)
@warning_ignore("unused_signal")
signal selected(Card)

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
@onready var gridVisualizer: GridCardVisualizer = $gridcard_visualizer
var statusEffects: Array[EventResource]

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
var play_bullets: Array[BulletResource]
var action_bullets: Array[BulletResource]
var social_bullets: Array[BulletResource]

func _ready() -> void:
	call_deferred("_after_ready")
	
func _after_ready() -> void:
	pass

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
	play_bullets.clear()
	action_bullets.clear()
	social_bullets.clear()
	for bullet in resource.bullets:
		match(bullet.bullet_type):
			BulletResource.BulletType.PLAY:
				play_bullets.append(bullet)
			BulletResource.BulletType.ACTION:
				action_bullets.append(bullet)
			BulletResource.BulletType.SOCIAL:
				social_bullets.append(bullet)
				
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
	if not GameManager.Instance.is_my_turn(): return
	card_sm.clicked_on()
	
func _on_right_click() -> void:
	if not CardViewer.Instance: return
	CardViewer.Instance.view_card(resource)

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
	if mouse_button_event.button_index == MOUSE_BUTTON_RIGHT:
		if mouse_button_event.pressed:
			_on_right_click()
				
func _on_drag_and_drop_component_2d_on_drop() -> void:
	pass # Replace with function body.

func add_to_events(event : EventResource):
	print("Appended")
	#resource.passive_events[PassiveEventResource.PassiveEvent.ON_START_OF_TURN].append(event)
	statusEffects.append(event)
	
func remove(event : EventResource):
	var index = statusEffects.find(event)
	statusEffects.remove_at(index)

# Invoking Bullet Events Here
# The networking magic happens here
func try_execute(bullet: BulletResource, idx: int) -> bool:
	# Currently only action and social have a cost for bullet activativations
	if bullet.bullet_events.is_empty(): return false
	match(bullet.bullet_type):
		BulletResource.BulletType.PLAY:
			queue_bullet_events.rpc(bullet.bullet_type, idx)
			if await queue_bullet_events(bullet.bullet_type, idx): return false
		BulletResource.BulletType.ACTION:
			if not PlayerStatistics.can_afford(PlayerStatistics.ResourceType.ACTION, bullet.bullet_cost): return false
			queue_bullet_events.rpc(bullet.bullet_type, idx)
			if await queue_bullet_events(bullet.bullet_type, idx): return false
			if not PlayerStatistics.purchase_attempt(PlayerStatistics.ResourceType.ACTION, bullet.bullet_cost): return false
		BulletResource.BulletType.SOCIAL:
			if not PlayerStatistics.can_afford(PlayerStatistics.ResourceType.SOCIAL, bullet.bullet_cost): return false
			queue_bullet_events.rpc(bullet.bullet_type, idx)
			if await queue_bullet_events(bullet.bullet_type, idx): return false
			if not PlayerStatistics.purchase_attempt(PlayerStatistics.ResourceType.SOCIAL, bullet.bullet_cost): return false
	return true
	
@rpc("call_remote", "any_peer", "reliable")
func queue_bullet_events(bullet_type: BulletResource.BulletType, idx: int) -> bool:
	match(bullet_type):
		BulletResource.BulletType.PLAY:
			EventManager.queue_event_group(play_bullets[idx].bullet_events, self)
			if await EventManager.process_event_queue(): return true
			on_play()
		BulletResource.BulletType.ACTION:
			EventManager.queue_event_group(action_bullets[idx].bullet_events, self)
			if await EventManager.process_event_queue(): return true
			on_action()
		BulletResource.BulletType.SOCIAL:
			EventManager.queue_event_group(social_bullets[idx].bullet_events, self)
			if await EventManager.process_event_queue(): return true
			on_social()
	# Process If there were added events from the card passives or not
	EventManager.process_event_queue()
	return false

# Passive Functions
func on_play(): 
	EventManager.queue_event_group(resource.passive_events[PassiveEventResource.PassiveEvent.ON_PLAY], self)
func on_action(): 
	EventManager.queue_event_group(resource.passive_events[PassiveEventResource.PassiveEvent.ON_ACTION], self)
func on_social(): 
	EventManager.queue_event_group(resource.passive_events[PassiveEventResource.PassiveEvent.ON_SOCIAL], self)
func on_enter_tree(): 
	EventManager.queue_event_group(resource.passive_events[PassiveEventResource.PassiveEvent.ON_ENTER_TREE], self)
func on_state_of_grid_change(): 
	EventManager.queue_event_group(resource.passive_events[PassiveEventResource.PassiveEvent.ON_STATE_OF_GRID_CHANGE], self)
func on_end_of_turn(): 
	EventManager.queue_event_group(resource.passive_events[PassiveEventResource.PassiveEvent.ON_END_OF_TURN], self)
func on_start_of_turn(): 
	EventManager.queue_event_group(resource.passive_events[PassiveEventResource.PassiveEvent.ON_START_OF_TURN], self)
func on_damage(): 
	EventManager.queue_event_group(resource.passive_events[PassiveEventResource.PassiveEvent.ON_DAMAGE], self)
func on_discard(): 
	EventManager.queue_event_group(resource.passive_events[PassiveEventResource.PassiveEvent.ON_DISCARD], self)
func on_burn(): 
	EventManager.queue_event_group(resource.passive_events[PassiveEventResource.PassiveEvent.ON_BURN], self)
func on_stack(): 
	EventManager.queue_event_group(resource.passive_events[PassiveEventResource.PassiveEvent.ON_STACK], self)
func on_flip_hide(): 
	EventManager.queue_event_group(resource.passive_events[PassiveEventResource.PassiveEvent.ON_FLIP_HIDE], self)
func on_flip_reveal(): 
	EventManager.queue_event_group(resource.passive_events[PassiveEventResource.PassiveEvent.ON_FLIP_REVEAL], self)
func on_before_move(): 
	EventManager.queue_event_group(resource.passive_events[PassiveEventResource.PassiveEvent.ON_BEFORE_MOVE], self)
func on_after_move(): 
	EventManager.queue_event_group(resource.passive_events[PassiveEventResource.PassiveEvent.ON_AFTER_MOVE], self)
func on_replace(): 
	EventManager.queue_event_group(resource.passive_events[PassiveEventResource.PassiveEvent.ON_REPLACE], self)
func on_freeze(): 
	EventManager.queue_event_group(resource.passive_events[PassiveEventResource.PassiveEvent.ON_FREEZE], self)
func on_quest_progress(): 
	EventManager.queue_event_group(resource.passive_events[PassiveEventResource.PassiveEvent.ON_QUEST_PROGRESS], self)
