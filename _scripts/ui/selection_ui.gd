extends Control
class_name SelectionUI

signal selection_complete
const PLAY_ICON = preload("uid://cx5x8lcn1vfcy")
const SOCIAL_ICON = preload("uid://tv4w2lagffrf")
const ACTION_ICON = preload("uid://cn0xhk718r4iv")
@onready var buttons: HBoxContainer = $TextureRect/Buttons
var _bullet_selected: BulletResource

func make_selection(bullet: BulletResource) -> void:
	_bullet_selected = bullet
	selection_complete.emit()
	
func get_play_selection(resource: CardResource) -> BulletResource:
	var selection_was_created: bool = false
	for bullet in resource.bullets:
		if bullet.bullet_type == BulletResource.BulletType.PLAY:
			create_button_by_bullet(bullet)
			selection_was_created = true
			
	if not selection_was_created:
		printerr("Playable Card has no Play bullets!")
		return null
			
	await selection_complete
	return _bullet_selected

func get_interaction_selection(resource: CardResource) -> BulletResource:
	var selection_was_created: bool = false
	for bullet in resource.bullets:
		if bullet.bullet_type == BulletResource.BulletType.SOCIAL \
		or bullet.bullet_type == BulletResource.BulletType.ACTION:
			create_button_by_bullet(bullet)
			selection_was_created = true
			
	if not selection_was_created:
		printerr("Interactable Card has no interactable bullets!")
		return null
		
	await selection_complete
	return _bullet_selected

func create_button_by_bullet(bullet: BulletResource):
	var new_button: Button = Button.new()
	
	match(bullet.bullet_type):
		BulletResource.BulletType.PLAY:
			new_button.icon = PLAY_ICON
		BulletResource.BulletType.SOCIAL:
			new_button.icon = SOCIAL_ICON
		BulletResource.BulletType.ACTION:
			new_button.icon = ACTION_ICON

	new_button.pressed.connect(func(): make_selection(bullet))
	buttons.add_child(new_button)
