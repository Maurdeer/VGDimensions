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
	
func hide_view() -> void:
	visible = false
	
func _on_close_button_pressed() -> void:
	hide_view()
