@tool
extends Node
class_name GridCardVisualizer

# Exists to deal with editor based card updating
@onready var card: Card = $".."
@export var card_resource: CardResource:
	get:
		if card:
			return card.resource
		return card_resource

# Purpose: Provide a seemless way of seeing updates to this node while in the editor.
# without needing to do it during runtime while also not needing to run this functionality
# during runtime.

func _ready() -> void:
	if not Engine.is_editor_hint() and (card_resource or (card and card.resource)):
		_on_values_change()

func _process(_delta) -> void:
	# Polling BS technically ok because its just in the editor,
	# But would be better if its event handeled
	if Engine.is_editor_hint() and (card_resource or (card and card.resource)):
		_on_values_change()
		
func _on_values_change() -> void:
	$background_container/card_background.texture = card_resource.background_art
	$card_art_container/card_art.texture = card_resource.card_art
