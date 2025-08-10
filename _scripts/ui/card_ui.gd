extends Control

# User Specifications
@export var card_res: Card

# Predetermined Utilities
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var card_texture: TextureRect = $Control/TextureRect

func _ready() -> void:
	card_texture.texture = card_res.card_art
	
# Interaction related
func _expand() -> void:
	animation_player.play("card_expand")
	
func _return_size() -> void:
	animation_player.play("card_return")


func _on_texture_button_mouse_entered() -> void:
	_expand()


func _on_texture_button_mouse_exited() -> void:
	_return_size()
	
func _on_texture_button_pressed() -> void:
	CardManager.Instance.rpc("spawn_new_card", {"card_res" : card_res})
	queue_free()
