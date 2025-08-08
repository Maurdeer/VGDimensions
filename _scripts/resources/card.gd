extends Resource
class_name Card

@export var card_art: Texture
enum CardType {FEATURE, ASSET}
@export var card_type: CardType

func _init(p_card_art: Texture = null, p_card_type: CardType = CardType.FEATURE):
	card_art = p_card_art
	card_type = p_card_type
