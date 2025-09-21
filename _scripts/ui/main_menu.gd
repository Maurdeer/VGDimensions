extends Control

@onready var ip_address_line_edit: LineEdit = $"VBoxContainer/HBoxContainer/ip-address_line-edit"
@onready var name_line_edit: LineEdit = $"VBoxContainer/name_line-edit"

func _on_host_button_pressed() -> void:
	if not _is_valid_name(name_line_edit.text): return 
	GNM.host(name_line_edit.text)
	$Chat.on_player_join()
	
func _on_join_button_pressed() -> void:
	if not _is_valid_name(name_line_edit.text): return 
	if not GNM.client(name_line_edit.text, ip_address_line_edit.text):
		ip_address_line_edit.text = ""
		ip_address_line_edit.placeholder_text = "Invalid IP Address"
	#$Chat.on_player_join()
	
func _is_valid_name(player_name: String) -> bool:
	return player_name != ""
