extends Control
class_name RiftGridSlot

signal OnClicked(Vector2i)
var grid_position: Vector2i

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event as InputEventMouseButton 
		if mouse_event.pressed:
			OnClicked.emit(grid_position)
