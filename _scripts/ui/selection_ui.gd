extends Control
class_name SelectionUI

signal selection_complete
const PLAY_ICON = preload("uid://cx5x8lcn1vfcy")
const SOCIAL_ICON = preload("uid://tv4w2lagffrf")
const ACTION_ICON = preload("uid://cn0xhk718r4iv")
@onready var buttons: VBoxContainer = $TextureRect/Buttons
var _bullet_selected: BulletResource
var _bullet_idx: int
func make_selection(bullet: BulletResource, idx: int) -> void:
	_bullet_selected = bullet
	_bullet_idx = idx
	selection_complete.emit()
	
func get_play_selection(card: Card):
	var selection_was_created: bool = false
	var idx: int = 0
	for play_bullet in card.play_bullets:
		create_button_by_bullet(play_bullet, idx)
		selection_was_created = true
		idx += 1
			
	if not selection_was_created:
		printerr("Playable Card has no Play bullets!")
		return null
			
	await selection_complete
	if not _bullet_selected or _bullet_idx < 0:
		return null
	return [_bullet_selected, _bullet_idx]

func get_interaction_selection(card: Card):
	var selection_was_created: bool = false
	var idx: int = 0
	for bullet in card.social_bullets:
		create_button_by_bullet(bullet, idx)
		selection_was_created = true
		idx += 1
		
	idx = 0
	for bullet in card.action_bullets:
		create_button_by_bullet(bullet, idx)
		selection_was_created = true
		idx += 1
			
	if not selection_was_created:
		printerr("Interactable Card has no interactable bullets!")
		return null
		
	await selection_complete
	if not _bullet_selected or _bullet_idx < 0:
		return null
	return [_bullet_selected, _bullet_idx]

func create_button_by_bullet(bullet: BulletResource, idx: int):
	var new_hbox: HBoxContainer = HBoxContainer.new()
	var new_button: Button = Button.new()
	var new_label: Label = Label.new()
	
	# TODO Make the text look a lot better; holy
	new_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	new_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	new_label.text = bullet.bullet_description
	new_label.set("theme_override_colors/font_color", Color.BLACK)
	
	match(bullet.bullet_type):
		BulletResource.BulletType.PLAY:
			new_button.icon = PLAY_ICON
		BulletResource.BulletType.SOCIAL:
			new_button.icon = SOCIAL_ICON
			new_button.text = "%s" % bullet.bullet_cost
		BulletResource.BulletType.ACTION:
			new_button.icon = ACTION_ICON 

	new_button.pressed.connect(func(): make_selection(bullet, idx))
	buttons.add_child(new_hbox)
	new_hbox.add_child(new_button)
	new_hbox.add_child(new_label)

func _on_texture_rect_2_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			make_selection(null, -1)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			make_selection(null, -1)
