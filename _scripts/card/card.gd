extends Node2D
class_name Card

# Change these signals to include the card parameter that is pushed into it.
signal played(Card)
signal interacted(Card)
signal selected(Vector2i)

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
@export var draggable: bool = true:
	set(value):
		draggable = value
		$drag_and_drop_component2D.draggable = value
var playable: bool = false
var interactable: bool = false
var selectable: bool = false
const SELECTION_UI = preload("uid://vei3yr63fqcj")

# Utilities
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Dynamic Stats
var hp: int
var grid_pos: Vector2
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
	revealed = true
	refresh_stats()
	call_deferred("_setup")
	
func _setup() -> void:
	$drag_and_drop_component2D.draggable = draggable
	
func _on_resource_change() -> void:
	for bullet in resource.bullets:
		if bullet.bullet_event: bullet.bullet_event.card_ref = self
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
	animation_player.play("flip_reveal")
	revealed = true
	if resource.on_flip_reveal: resource.on_flip_reveal()

func flip_hide() -> void:
	animation_player.play("flip_hide")
	revealed = false
	if resource.on_flip_hide: resource.on_flip_hide()
	
func play() -> void:
	if _play_bullets.size() == 1:
		# Execute function right way, no selection needed!
		if _play_bullets[0].bullet_event: _play_bullets[0].bullet_event.execute()
	elif _play_bullets.size() > 1:
		# TODO: Pull Up Play Selection UI to pick an event to do.
		# Let the function call poll until that option was picked
		var select_UI: SelectionUI = SELECTION_UI.instantiate()
		get_tree().root.add_child(select_UI)
		select_UI.setup_play_selections(resource)
		await select_UI.selection_complete
	# Passive Call Now
	played.emit(self)
	resource.on_play()
	
func interact() -> void:
	# TODO: Pull Up Grid Selection UI to pick an event to do.
	# Let the function call poll until that option was picked
	return
	var select_UI: SelectionUI = SELECTION_UI.instantiate()
	get_tree().root.add_child(select_UI)
	select_UI.setup_interact_selections(resource)
	await select_UI.selection_complete
	interacted.emit(self)

# Card Input Functions
func _on_double_click() -> void:
	flip()

func _on_single_click() -> void:
	if CardInspector.Instance: CardInspector.Instance.set_card(self)
	if playable: play()
	elif interactable: interact()
	elif selectable: selected.emit(grid_pos)
	

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
