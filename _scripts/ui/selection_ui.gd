extends Control
class_name SelectionUI

signal selection_complete
const PLAY_ICON = preload("uid://cx5x8lcn1vfcy")
const SOCIAL_ICON = preload("uid://tv4w2lagffrf")
const ACTION_ICON = preload("uid://cn0xhk718r4iv")
@onready var buttons: HBoxContainer = $TextureRect/Buttons


func make_selection() -> void:
	selection_complete.emit()
	queue_free()
	
func setup_play_selections(resource: CardResource) -> void:
	for bullet in resource.bullets:
		if bullet.bullet_type == BulletResource.BulletType.PLAY:
			create_button_by_bullet(resource, bullet)

func setup_interaction_selections(resource: CardResource) -> void:
	var selection_was_created: bool = false
	for bullet in resource.bullets:
		if bullet.bullet_type == BulletResource.BulletType.SOCIAL \
		or bullet.bullet_type == BulletResource.BulletType.ACTION:
			create_button_by_bullet(resource, bullet)
			selection_was_created = true
			
	if not selection_was_created:
		printerr("Interactable Card has no interactable bullets!")
		make_selection()

func create_button_by_bullet(resource: CardResource, bullet: BulletResource):
	var new_button: Button = Button.new()
	
	match(bullet.bullet_type):
		BulletResource.BulletType.PLAY:
			new_button.icon = PLAY_ICON
		BulletResource.BulletType.SOCIAL:
			new_button.icon = SOCIAL_ICON
			new_button.pressed.connect(resource.on_social)
		BulletResource.BulletType.ACTION:
			new_button.icon = ACTION_ICON
			new_button.pressed.connect(resource.on_action)
			
		
	new_button.pressed.connect(func(): bullet.try_execute())
	new_button.pressed.connect(make_selection)
	buttons.add_child(new_button)
