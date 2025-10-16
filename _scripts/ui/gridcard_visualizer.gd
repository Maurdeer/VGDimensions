extends Sprite2D
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

signal dissolve_complete
var dissolve_active: bool = false
var dissolve_value: float = 0
@onready var shaderMaterial = $card_art_container/card_art.material
func _process(delta: float) -> void:
	if not dissolve_active: return
	dissolve_value += delta
	shaderMaterial.set_shader_parameter("dissolve_amount", dissolve_value)
	if dissolve_value >= 1:
		dissolve_active = false
		dissolve_value = 0
		dissolve_complete.emit()

func _ready() -> void:
	if card and (card.resource or card_resource):
		card.on_stats_change.connect(_on_stat_change)
		_on_values_change()
		
func _on_values_change() -> void:
	$background_container/card_background.texture = card_resource.background_art
	$card_art_container/card_art.texture = card_resource.card_art
	
	_on_stat_change()
	
	$GUI/Icons/ACTION.visible = not card.action_bullets.is_empty()
	$GUI/Icons/SOCIAL.visible = not card.social_bullets.is_empty()
	$GUI/Icons/PASSIVE.visible = false
	
func _on_stat_change() -> void:
	if card.hp < 0: $GUI/Icons/HP.visible = false
	else:
		$GUI/Icons/HP.visible = true
		$GUI/Icons/HP/Label.text = "%s" % card.hp

func dissolve_shader() -> bool:
	dissolve_active = true
	await dissolve_complete
	return true
