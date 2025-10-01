extends Control

@onready var message_text: LineEdit = $MarginContainer/VBoxContainer/HBoxContainer/message_text
@onready var messages: VBoxContainer = $MarginContainer/VBoxContainer/ScrollContainer/Messages
@onready var scroll_container: ScrollContainer = $MarginContainer/VBoxContainer/ScrollContainer
@onready var scrollbar = scroll_container.get_v_scroll_bar()
var message_strings: Array[String]

func _ready() -> void:
	scrollbar.changed.connect(_on_scrollbar_changed)
	GNM.player_connected.connect(_on_player_join)

func send_message(msg: String) -> void:
	var geared_msg = "(%s): %s" % [GNM.player_info['name'], msg]
	rpc("create_message", geared_msg)

@rpc("any_peer", "call_local")
func create_message(msg: String) -> void:
	var label: Label = Label.new()
	message_strings.append(msg)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.text = msg
	messages.add_child(label)
	label.grab_focus()
	
@rpc("any_peer", "call_local")
func create_messages(msgs: Array[String]) -> void:
	for msg in msgs:
		create_message(msg)
	
func _on_send_button_pressed() -> void:
	send_message(message_text.text)
	message_text.text = ""
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		var event_key: InputEventKey = event
		if event.pressed and event_key.keycode == KEY_ENTER:
			_on_send_button_pressed()
			
func _on_scrollbar_changed() -> void:
	scroll_container.scroll_vertical = scrollbar.max_value
	
func _on_player_join(pid, _player_info) -> void:
	if multiplayer.is_server():
		if pid == 1: 
			rpc("create_message", "%s has Joined Session" % GNM.players[pid]['name'])
		else:
			rpc_id(pid, "create_messages", message_strings)
			rpc("create_message", "%s has Joined Session" % GNM.players[pid]['name'])
