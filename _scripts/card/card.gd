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
		$gridcard_shape.draggable = value
		$card_shape.draggable = value
		
const SELECTION_UI = preload("uid://vei3yr63fqcj")

# Utilities
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var card_sm: CardStateMachine = $CardSM
@onready var card_shape: DragAndDropComponent2D = $card_shape
@onready var gridcard_shape: DragAndDropComponent2D = $gridcard_shape
@onready var gridVisualizer: GridCardVisualizer = $gridcard_visualizer
var passive_events: Array[Array]

# Dynamic Stats
var hp: int:
	set(value):
		hp = value
		on_stats_change.emit()
var grid_pos: Vector2i = Vector2i(-1, -1)
var deck_pos: int = -1
var owner_pid: int = -1
var revealed: bool
var temporary: bool = false
var interactable: bool = false:
	set(value):
		gridcard_shape.interactable = value
		card_shape.interactable = value
		interactable = value
var card_id: int
enum CardDirection {
	NORTH,
	NORTH_EAST,
	EAST,
	SOUTH_EAST,
	SOUTH,
	SOUTH_WEST,
	WEST,
	NORTH_WEST
}
var card_dir: CardDirection

# Dynamic Bullet Functions
var play_bullets: Array[BulletResource]
var action_bullets: Array[BulletResource]
var social_bullets: Array[BulletResource]

# Hover timer for card viewer
var hover_timer: Timer
var is_hovering: bool = false
var hover_delay: float = 0.8

func _ready() -> void:
	call_deferred("_after_ready")
	
func _after_ready() -> void:
	gridcard_shape.on_hover_enter.connect(_on_hover_enter)
	gridcard_shape.on_hover_left.connect(_on_hover_left)
	card_shape.on_hover_enter.connect(_on_hover_enter)
	card_shape.on_hover_left.connect(_on_hover_left)

func set_up(p_card_id: int, p_resource: CardResource) -> void:
	card_id = p_card_id
	resource = p_resource

func _enter_tree() -> void:
	#refresh_stats()
	on_enter_tree()
	call_deferred("_setup")
	
func _setup() -> void:
	# Play the animation when entering the tree
	if not revealed: animation_player.play("flip_hide", -1, 1, true)
	else: animation_player.play("flip_reveal", -1, 1, true)
	
	# Let card be draggable on launch or not
	card_shape.draggable = draggable
	gridcard_shape.draggable = draggable

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
				
	reset_passive_events()
	
func reset_passive_events() -> void:
	# TODO: Unopmtimized, clean up :3
	passive_events.clear()
	passive_events.resize(PassiveEventResource.PassiveEvent.size() + PassiveEventResource.GlobalEvent.size())
	for bullet in resource.bullets:
		if bullet.bullet_type != BulletResource.BulletType.PASSIVE: continue
		var passive_event_resources: Array[PassiveEventResource] = []
		if bullet.is_multi_event:
			passive_event_resources = bullet.passive_events
		elif bullet.passive_event:
			passive_event_resources.append(bullet.passive_event)
			
		for passive_event_resource in passive_event_resources:
			if passive_event_resource.is_global:
				passive_events[passive_event_resource.global_event_type].append(passive_event_resource.event)
			else:
				passive_events[passive_event_resource.passive_event_type].append(passive_event_resource.event)
				

	
func refresh_stats() -> void:
	hp = resource.starting_hp
	global_rotation_degrees = 0
	reset_passive_events()
	#call_deferred("_on_values_change")

# Return whether or not the card reach zero hp
func damage(amount: int) -> bool:
	if hp < 0:
		return false
	var discarded: bool = false
	if not card_sm.is_state(CardStateMachine.StateType.IN_RIFT): return discarded
	hp -= amount
	on_damage()
	RiftGrid.Instance.emit_global_event(PassiveEventResource.GlobalEvent.ON_CARD_DAMAGE, self)
	if hp <= 0:
		hp = 0
		discarded = true
		RiftGrid.Instance.discard_card(self)
	return discarded
	
func rotate_card(dir: CardDirection):
	card_dir = dir
	var rotate_to: float = 0
	match (dir):
		CardDirection.NORTH: rotate_to = 0
		CardDirection.NORTH_EAST: rotate_to = 45
		CardDirection.EAST: rotate_to = 90
		CardDirection.SOUTH_EAST: rotate_to = 135
		CardDirection.SOUTH: rotate_to = 180
		CardDirection.SOUTH_WEST: rotate_to = 225
		CardDirection.WEST: rotate_to = 270
		CardDirection.NORTH_WEST: rotate_to = 315
	while global_rotation_degrees != rotate_to:
		rotate_toward(global_rotation_degrees, rotate_to, get_process_delta_time())
		await get_tree().create_timer(get_process_delta_time()).timeout

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
	
func _on_right_click() -> void:
	if not CardViewer.Instance or CardViewer.Instance.visible: return
	CardViewer.Instance.view_card(resource)

func _on_single_click() -> void:
	#if CardInspector.Instance: CardInspector.Instance.set_card(self)
	if not GameManager.Instance.is_my_turn(): return
	card_sm.clicked_on()

func _on_hover_enter() -> void:
	if not interactable: return
	if gridcard_shape.is_dragging or card_shape.is_dragging: return
	# Don't start hover if CardViewer is already open
	if CardViewer.Instance and CardViewer.Instance.visible: return
	
	is_hovering = true
	if not hover_timer:
		hover_timer = Timer.new()
		add_child(hover_timer)
		hover_timer.wait_time = hover_delay
		hover_timer.one_shot = true
		hover_timer.timeout.connect(_on_hover_timeout)
	hover_timer.start()

func _on_hover_left() -> void:
	is_hovering = false
	if hover_timer:
		hover_timer.queue_free()
		hover_timer = null

func _on_hover_timeout() -> void:	
	# Check we're still hovering and not dragging before showing viewer
	if (is_hovering and not (card_shape.is_dragging or gridcard_shape.is_dragging) 
	and CardViewer.Instance and not CardViewer.Instance.visible):
		# (Ryan) This is where you enable hover behavior here
		#CardViewer.Instance.view_card(resource)
		pass
	else:
		print("Hover timeout cancelled - conditions not met")

var _pressed_previously: bool = false

func _on_gridcard_shape_gui_input(event: InputEvent) -> void:
	_process_input_event(event)

func _on_card_shape_gui_input(event: InputEvent) -> void:
	_process_input_event(event)
		
func _process_input_event(event: InputEvent) -> void:
	if not interactable or not event is InputEventMouseButton: return
	var mouse_button_event: InputEventMouseButton = event
	if mouse_button_event.pressed and not _pressed_previously:
		# Cancel hover timer when player starts interacting
		if hover_timer and hover_timer.time_left > 0:
			hover_timer.stop()
			hover_timer.queue_free()
			hover_timer = null
			is_hovering = false
		
		_pressed_previously = true
		if mouse_button_event.button_index == MOUSE_BUTTON_LEFT:
			if mouse_button_event.double_click:
				_on_double_click()
			else:
				_on_single_click()
		elif mouse_button_event.button_index == MOUSE_BUTTON_RIGHT:
			_on_right_click()
	_pressed_previously = mouse_button_event.pressed
				
func _on_drag_and_drop_component_2d_on_drop() -> void:
	pass # Replace with function body.
	
func add_passive_event(event: EventResource):
	if event is TemporaryEffect:
		# Specific parameter your guranteed
		passive_events[event.invoked_when].append(event)
		event.m_card_invoker= self
		event.on_effect_apply()
	else:
		# No logic of duration, so you may have wanted this effect to be permenant
		push_warning("Newly added passive event wasn't a temporary effect, await new logic soon!")
	
func remove_passive_event(event : EventResource):
	if event is TemporaryEffect:
		# Specific parameter your guranteed
		var idx: int = passive_events[event.invoked_when].find(event)
		if idx >= 0: passive_events[event.invoked_when].remove_at(idx)
	else:
		# No logic of duration, so you may have wanted this effect to be permenant
		push_warning("Newly added passive event wasn't a temporary effect, await new logic soon!")

# Invoking Bullet Events Here
# The networking magic happens here
func try_execute(bullet: BulletResource, idx: int) -> bool:
	# Currently only action and social have a cost for bullet activativations
	# TODO: Discrete math anyone?
	if (bullet.is_multi_event and not bullet.bullet_events) or \
	(not bullet.is_multi_event and not bullet.bullet_event): return false
	match(bullet.bullet_type):
		BulletResource.BulletType.PLAY:
			if await EventManager.queue_and_process_bullet_event(card_id, bullet.bullet_type, idx): return false
		BulletResource.BulletType.ACTION:
			if not PlayerStatistics.can_afford(PlayerStatistics.ResourceType.ACTION, bullet.bullet_cost): return false
			if await EventManager.queue_and_process_bullet_event(card_id, bullet.bullet_type, idx): return false
			if not PlayerStatistics.purchase_attempt(PlayerStatistics.ResourceType.ACTION, bullet.bullet_cost): return false
		BulletResource.BulletType.SOCIAL:
			if not PlayerStatistics.can_afford(PlayerStatistics.ResourceType.SOCIAL, bullet.bullet_cost): return false
			if await EventManager.queue_and_process_bullet_event(card_id, bullet.bullet_type, idx): return false
			if not PlayerStatistics.purchase_attempt(PlayerStatistics.ResourceType.SOCIAL, bullet.bullet_cost): return false
	return true

# Passive Functions effecting card itself
func on_play():
	EventManager.queue_event_group(passive_events[PassiveEventResource.PassiveEvent.ON_PLAY], self)
func on_action():
	EventManager.queue_event_group(passive_events[PassiveEventResource.PassiveEvent.ON_ACTION], self)
func on_social():
	EventManager.queue_event_group(passive_events[PassiveEventResource.PassiveEvent.ON_SOCIAL], self)
func on_enter_tree():
	EventManager.queue_event_group(passive_events[PassiveEventResource.PassiveEvent.ON_ENTER_TREE], self)
func on_state_of_grid_change():
	EventManager.queue_event_group(passive_events[PassiveEventResource.GlobalEvent.ON_STATE_OF_GRID_CHANGE], self)
func on_end_of_turn():
	EventManager.queue_event_group(passive_events[PassiveEventResource.GlobalEvent.ON_END_OF_TURN], self)
func on_start_of_turn():
	EventManager.queue_event_group(passive_events[PassiveEventResource.GlobalEvent.ON_START_OF_TURN], self)
func on_damage():
	EventManager.queue_event_group(passive_events[PassiveEventResource.PassiveEvent.ON_DAMAGE], self)
func on_discard():
	EventManager.queue_event_group(passive_events[PassiveEventResource.PassiveEvent.ON_DISCARD], self)
func on_burn():
	EventManager.queue_event_group(passive_events[PassiveEventResource.PassiveEvent.ON_BURN], self)
func on_stack():
	EventManager.queue_event_group(passive_events[PassiveEventResource.PassiveEvent.ON_STACK], self)
func on_flip_hide():
	EventManager.queue_event_group(passive_events[PassiveEventResource.PassiveEvent.ON_FLIP_HIDE], self)
func on_flip_reveal():
	EventManager.queue_event_group(passive_events[PassiveEventResource.PassiveEvent.ON_FLIP_REVEAL], self)
func on_before_move():
	EventManager.queue_event_group(passive_events[PassiveEventResource.PassiveEvent.ON_BEFORE_MOVE], self)
func on_after_move():
	EventManager.queue_event_group(passive_events[PassiveEventResource.PassiveEvent.ON_AFTER_MOVE], self)
func on_replace():
	EventManager.queue_event_group(passive_events[PassiveEventResource.PassiveEvent.ON_REPLACE], self)
func on_freeze():
	EventManager.queue_event_group(passive_events[PassiveEventResource.PassiveEvent.ON_FREEZE], self)
func on_quest_progress(): 
	EventManager.queue_event_group(passive_events[PassiveEventResource.GlobalEvent.ON_QUEST_PROGRESS], self)
