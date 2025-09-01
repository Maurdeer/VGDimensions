extends Node2D
class_name Card

@export var resource: CardResource:
	set(value):
		resource = value
		_on_resource_change()

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
		_play_bullets[0].bullet_event.execute()
	elif _play_bullets.size() > 1:
		# TODO: Pull Up Play Selection UI to pick an event to do.
		# Let the function call poll until that option was picked
		pass
		
	# Passive Call Now
	resource.on_play()
	
func interact() -> void:
	# TODO: Pull Up Grid Selection UI to pick an event to do.
	# Let the function call poll until that option was picked
	pass

# Card Input Functions
func _on_drag_and_drop_component_2d_on_double_click() -> void:
	flip()

func _on_drag_and_drop_component_2d_on_single_click() -> void:
	CardInspector.Instance.set_card(self)
	if not playable: return
	play()

func _on_drag_and_drop_component_2d_on_drop() -> void:
	pass # Replace with function body.

func _on_drag_and_drop_component_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
