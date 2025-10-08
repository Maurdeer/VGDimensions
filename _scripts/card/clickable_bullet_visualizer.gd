@tool
extends BulletVisualizer
class_name ClickableBulletVisualizer

@export var play_active: bool = false
@export var interact_active: bool = false

#TODO: REMOVE THIS AND DECOUPLE IT FROM THE GAME

func _on_bullet_type_change() -> void:
	$bullet_frame.visible = true
	$TextureButton.visible = false
	$TextureButton.disabled = true
	super._on_bullet_type_change()

func _on_bullet_type_play():
	$bullet_frame.visible = false
	$TextureButton.visible = true
	$TextureButton/icon.texture = play_icon
	$TextureButton.disabled = play_active
	
func _on_bullet_type_action():
	$bullet_frame.visible = false
	$TextureButton.visible = true
	$TextureButton/icon.texture = action_icon
	$TextureButton.disabled = interact_active
	
func _on_bullet_type_social():
	$bullet_frame.visible = false
	$TextureButton.visible = true
	$TextureButton/icon.texture = social_icon
	$TextureButton.disabled = interact_active

func _on_texture_button_button_up() -> void:
	pass
