extends Control

@onready var message_text: LineEdit = $MarginContainer/VBoxContainer/HBoxContainer/message_text
@onready var messages: VBoxContainer = $MarginContainer/VBoxContainer/Messages

func send_message(msg: String) -> void:
	var geared_msg = "(%s): %s" % [GNM.player_name, msg]
	rpc("create_message", geared_msg)

@rpc("any_peer", "call_local")
func create_message(msg: String) -> void:
	var label: Label = Label.new()
	label.text = msg
	messages.add_child(label)
	
func _on_send_button_pressed() -> void:
	send_message(message_text.text)
	message_text.text = ""
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		var event_key: InputEventKey = event
		if event.pressed and event_key.keycode == KEY_ENTER:
			_on_send_button_pressed()
			
