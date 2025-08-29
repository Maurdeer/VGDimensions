extends BulletVisualizer
class_name ClickableBulletVisualizer

func _on_bullet_type_change() -> void:
	$bullet_frame.visible = true
	$TextureButton.visible = false
	super._on_bullet_type_change()

func _on_bullet_type_play():
	$bullet_frame.visible = false
	$TextureButton.visible = true
	$TextureButton/icon.texture = play_icon
	
func _on_bullet_type_action():
	$bullet_frame.visible = false
	$TextureButton.visible = true
	$TextureButton/icon.texture = action_icon
	
func _on_bullet_type_social():
	$bullet_frame.visible = false
	$TextureButton.visible = true
	$TextureButton/icon.texture = social_icon

func _on_texture_button_button_up() -> void:
	bullet_resource.bullet_event.execute()
	# TODO: Add Meditaor Complete Function or something here
