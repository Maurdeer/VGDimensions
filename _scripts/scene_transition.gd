extends Node

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://_scenes/networking/network_lobby.tscn")
