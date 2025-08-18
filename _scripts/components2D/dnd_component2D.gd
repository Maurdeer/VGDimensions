extends Area2D
class_name DragAndDropComponent2D

var is_dragging: bool = false
@onready var _parent: Node2D = $".."
signal on_single_click
signal on_double_click


func _process(delta):
	_input_process()

func _input_process() -> void:
	if is_dragging: 
		follow_mouse()

func follow_mouse():
	_parent.global_position = get_global_mouse_position()

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if not event is InputEventMouseButton: return
	var mouse_button_event: InputEventMouseButton = event
	if mouse_button_event.button_index == MOUSE_BUTTON_LEFT:
		if mouse_button_event.pressed:
			is_dragging = true
			
			if mouse_button_event.double_click:
				on_double_click.emit()
			else:
				on_single_click.emit()
		else:
			is_dragging = false

func _on_mouse_entered() -> void:
	if is_dragging: return
	_parent.scale = Vector2(1.05, 1.05)
	
func _on_mouse_exited() -> void:
	if is_dragging: return
	_parent.scale = Vector2(1, 1)
