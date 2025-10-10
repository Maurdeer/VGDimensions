extends Control

@onready var ip_address_line_edit: LineEdit = $"VBoxContainer/HBoxContainer/ip-address_line-edit"
@onready var name_line_edit: LineEdit = $"VBoxContainer/name_line-edit"
@onready var h_box_container: HBoxContainer = $VBoxContainer/HBoxContainer
@onready var client_options: HBoxContainer = $VBoxContainer/CLIENT_OPTIONS
@onready var host_options: HBoxContainer = $VBoxContainer/HOST_OPTIONS

func _on_host_button_pressed() -> void:
	if not _is_valid_name(name_line_edit.text): return 
	GNM.host(name_line_edit.text)
	h_box_container.visible = false
	host_options.visible = true
	
func _on_join_button_pressed() -> void:
	if not _is_valid_name(name_line_edit.text): return 
	if not GNM.client(name_line_edit.text, ip_address_line_edit.text): return
	ip_address_line_edit.text = ""
	h_box_container.visible = false
	client_options.visible = true
	
func _on_disconnect() -> void:
	h_box_container.visible = true
	client_options.visible = false
	host_options.visible = false
	
func _on_start_game_button_pressed() -> void:
	GNM.load_game.rpc("res://_scenes/networking/multiplayer.tscn")
	
func _is_valid_name(player_name: String) -> bool:
	return player_name != ""
	

func _on_client_leave_button_pressed() -> void:
	GNM.remove_multiplayer_peer()
	_on_disconnect()

func _on_host_leave_button_pressed() -> void:
	GNM.remove_multiplayer_peer()
	_on_disconnect()
