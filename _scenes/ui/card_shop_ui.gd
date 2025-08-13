extends Control
class_name CardShopUI
# TODO: This will be the UI to show the information about each card
# User Specifications
@export var m_card_res: Card

# Predetermined Utilities
@onready var m_animation_player: AnimationPlayer = $AnimationPlayer
@onready var m_card_texture: TextureRect = $Control/TextureRect

func set_card_reference(p_card_res: Card) -> void:
	m_card_res = p_card_res
	_on_card_change()

func _on_card_change() -> void:
	m_card_texture.texture = m_card_res.front_texture
	
func _on_texture_button_pressed() -> void:
	# Give card to player
	PlayerHand.Instance.add_card(m_card_res)
	
	# Tell all peers that this card has been purchased via an RPC of some sort
	queue_free()
