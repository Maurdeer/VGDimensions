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
	if card and (card.resource or card_resource):
		_on_values_change()
		
func _on_values_change() -> void:
	$background_container/card_background.texture = card_resource.background_art
	$card_art_container/card_art.texture = card_resource.card_art
	if card.hp < 0: $GUI/Icons/HP.visible = false
	else:
		$GUI/Icons/HP.visible = true
		$GUI/Icons/HP/Label.text = "%s" % card.hp
	
	$GUI/Icons/ACTION.visible = not card._action_bullets.is_empty()
	$GUI/Icons/SOCIAL.visible = not card._social_bullets.is_empty()
	$GUI/Icons/PASSIVE.visible = false
