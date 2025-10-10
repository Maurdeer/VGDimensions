extends Control

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if (event as InputEventKey).keycode == KEY_ESCAPE:
			visible = true
			


func _on_disconnect_from_server_pressed() -> void:
	GNM.disconnect_self()


func _on_back_to_game_button_pressed() -> void:
	visible = false
