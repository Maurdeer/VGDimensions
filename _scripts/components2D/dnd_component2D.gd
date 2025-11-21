extends Control
class_name DragAndDropComponent2D

@export_group("Specifications")
@export var snap_to_original_position: bool = true
var draggable: bool = true
var is_dragging: bool = false
@onready var _parent: Node2D = $".."
signal on_drop
signal on_hover_enter
signal on_hover_left

var pre_drag_pos: Vector2
var interactable: bool = true
var _offset: Vector2

var scale_due_to_hover: bool
var _hovering_over_area_temp: DropSlot2D

func _ready() -> void:
	scale_prior_to_hover = _parent.scale

func _process(_delta):
	_input_process()

func _input_process() -> void:
	if is_dragging: 
		follow_mouse()

func follow_mouse():
	_parent.global_position = get_global_mouse_position() + _offset

func _gui_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton or not draggable: return
	var mouse_button_event: InputEventMouseButton = event
	if mouse_button_event.button_index == MOUSE_BUTTON_LEFT:
		if mouse_button_event.pressed:
			_drag()
		elif is_dragging:
			_drop()

var scale_prior_to_hover: Vector2
func _on_mouse_entered() -> void:
	if not interactable or is_dragging: return
	hover()
	
func _on_mouse_exited() -> void:
	if not interactable or is_dragging or not scale_prior_to_hover: return
	unhover()
	
func _drag() -> void:
	is_dragging = draggable
	_offset = _parent.global_position - _parent.get_global_mouse_position()
	pre_drag_pos = _parent.global_position
	
func _drop() -> void:
	if snap_to_original_position:
		_parent.global_position = pre_drag_pos
	
	# Call drop functions
	if _hovering_over_area_temp: _hovering_over_area_temp.drop(self)
	on_drop.emit()
	pre_drag_pos = _parent.global_position
	is_dragging = false
	
func hover() -> void:
	if scale_due_to_hover: return
	scale_due_to_hover = true
	scale_prior_to_hover = _parent.scale
	_parent.scale *= 1.05
	on_hover_enter.emit()
	
func unhover() -> void:
	scale_due_to_hover = false
	_parent.scale = scale_prior_to_hover
	on_hover_left.emit()

func _on_area_2d_area_entered(area: Area2D) -> void:
	var dropslot: DropSlot2D = area as DropSlot2D
	if not dropslot: return
	_hovering_over_area_temp = dropslot

func _on_area_2d_area_exited(area: Area2D) -> void:
	if not _hovering_over_area_temp: return
	var dropslot: DropSlot2D = area as DropSlot2D
	if not dropslot or dropslot != _hovering_over_area_temp: return
	_hovering_over_area_temp = null
