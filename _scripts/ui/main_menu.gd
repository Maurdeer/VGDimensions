extends Control

@onready var ip_address_line_edit: LineEdit = $"VBoxContainer/HBoxContainer/ip-address_line-edit"
@onready var name_line_edit: LineEdit = $"VBoxContainer/name_line-edit"
@onready var start_game_button: Button = $VBoxContainer/start_game_button
@onready var label: Label = $VBoxContainer/Label
@onready var h_box_container: HBoxContainer = $VBoxContainer/HBoxContainer

func _on_host_button_pressed() -> void:
	if not _is_valid_name(name_line_edit.text): return 
	GNM.host(name_line_edit.text)
	h_box_container.visible = false
	start_game_button.visible = true
	
func _on_join_button_pressed() -> void:
	if not _is_valid_name(name_line_edit.text): return 
	if not GNM.client(name_line_edit.text, ip_address_line_edit.text): return
	ip_address_line_edit.text = ""
	h_box_container.visible = false
	label.visible = true
	
	
func _on_start_game_button_pressed() -> void:
	GNM.load_game.rpc("res://_scenes/networking/multiplayer.tscn")
	
func _is_valid_name(player_name: String) -> bool:
	return player_name != ""
