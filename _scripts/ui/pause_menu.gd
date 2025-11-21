extends Control

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if (event as InputEventKey).keycode == KEY_ESCAPE:
			visible = true
	
func _on_disconnect_from_server_pressed() -> void:
	GNM.disconnect_self()

func _on_back_to_game_button_pressed() -> void:
	visible = false

func _on_settings_button_pressed() -> void:
	$SettingsPanel.visible = true

func _on_close_button_pressed() -> void:
	$SettingsPanel.visible = false
