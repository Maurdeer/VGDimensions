extends Resource
class_name Card

@export var name: String
@export var front_texture: Texture
enum CardType {FEATURE, ASSET}
@export var type: CardType


func _init(p_name: String = "", p_front_texture: Texture = null, p_type: CardType = CardType.FEATURE):
	name = p_name
	front_texture = p_front_texture
	type = p_type
