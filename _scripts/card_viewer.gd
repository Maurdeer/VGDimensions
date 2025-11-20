extends Control
class_name CardViewer

static var Instance: CardViewer
@onready var card_visualizer: CardVisualizer = $Control/card_visualizer

func _ready() -> void:
	# Initialize Singleton
	if Instance: 
		queue_free()
		return
	Instance = self
func view_card(card_resource: CardResource) -> void:
	visible = true
	card_visualizer.card_resource = card_resource
	card_visualizer.icons.visible = false
	
func hide_view() -> void:
	visible = false

#func _on_control_mouse_exited() -> void:
	#hide_view()

func _gui_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton: return
	var mouse_button_event: InputEventMouseButton = event
	if mouse_button_event.button_index == MOUSE_BUTTON_LEFT and mouse_button_event.pressed:
		hide_view()


func _on_texture_rect_gui_input(event: InputEvent) -> void:
	_gui_input(event)

func _on_control_gui_input(event: InputEvent) -> void:
	_gui_input(event)
