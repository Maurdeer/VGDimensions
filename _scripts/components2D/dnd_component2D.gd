extends Area2D
class_name DragAndDropComponent2D

var is_dragging: bool = false
@onready var _parent: Node2D = $".."
signal on_single_click
signal on_double_click
var draggable: bool = true


func _process(_delta):
	_input_process()

func _input_process() -> void:
	if is_dragging: 
		follow_mouse()

func follow_mouse():
	_parent.global_position = get_global_mouse_position()

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if not event is InputEventMouseButton or not draggable: return
	var mouse_button_event: InputEventMouseButton = event
	if mouse_button_event.button_index == MOUSE_BUTTON_LEFT:
		if mouse_button_event.pressed:
			is_dragging = true
			
			if mouse_button_event.double_click:
				on_double_click.emit()
			else:
				on_single_click.emit()
		else:
			var cardSlotFound = checkForCardSlot()
			if cardSlotFound:
				#print()
				_parent.global_position = cardSlotFound.global_position
			is_dragging = false

# Implementation taken from Godot 4 Card Game Tutorial #3 Card Slots
# You know this isn't GPT because only a human can be this bad.
# This can't be right bc we aren't really using Collision Masks rn but wtv.
func checkForCardSlot():
	var spaceState = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = 2
	var result = spaceState.intersect_point(parameters)
	if result.size() > 0:
		print("Collision occured")
		print(result[0].collider.get_parent())
		return result[0].collider.get_parent()
	return null

var scale_prior_to_hover: Vector2
func _on_mouse_entered() -> void:
	if is_dragging: return
	scale_prior_to_hover = _parent.scale
	_parent.scale *= 1.05
	
func _on_mouse_exited() -> void:
	if is_dragging or not scale_prior_to_hover: return
	_parent.scale = scale_prior_to_hover
