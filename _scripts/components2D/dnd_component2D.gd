extends Area2D
class_name DragAndDropComponent2D

@export_group("Specifications")
@export var snap_to_original_position: bool = true

var is_dragging: bool = false
@onready var _parent: Node2D = $".."
signal on_single_click
signal on_double_click
signal on_drop
var draggable: bool = true
var pre_drag_pos: Vector2

func _ready() -> void:
	pre_drag_pos = _parent.global_position

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
			# Dragging
			is_dragging = true
		else:
			# Dropped
			on_drop.emit()
			_parent.global_position = pre_drag_pos
			
			# Call drop functions
			if hovering_over_area_temp: hovering_over_area_temp.drop(self)
			pre_drag_pos = _parent.global_position
			is_dragging = false

var scale_prior_to_hover: Vector2
func _on_mouse_entered() -> void:
	if is_dragging: return
	scale_prior_to_hover = _parent.scale
	_parent.scale *= 1.05
	
func _on_mouse_exited() -> void:
	if is_dragging or not scale_prior_to_hover: return
	_parent.scale = scale_prior_to_hover

var hovering_over_area_temp: DropSlot2D
func _on_area_entered(area: Area2D) -> void:
	var dropslot: DropSlot2D = area as DropSlot2D
	if not dropslot: return
	hovering_over_area_temp = dropslot
	
func _on_area_exited(area: Area2D) -> void:
	if not hovering_over_area_temp: return
	var dropslot: DropSlot2D = area as DropSlot2D
	if not dropslot or dropslot != hovering_over_area_temp: return
	hovering_over_area_temp = null
