@tool
extends HBoxContainer
class_name BulletVisualizer

const play_icon: Texture = preload("res://art/card_ui/play.png")
const action_icon: Texture = preload("res://art/card_ui/action.png")
const defeat_icon: Texture = preload("res://art/card_ui/damage.png")
const social_icon: Texture = preload("res://art/card_ui/social.png")
const discard_icon: Texture = preload("res://art/card_ui/damage.png")
const passive_icon: Texture = preload("res://art/card_ui/passive.png")

var bullet_resource: BulletResource:
	set(value):
		bullet_resource = value
		call_deferred("_on_values_change")
		
func _ready() -> void:
	
	if not Engine.is_editor_hint() and bullet_resource:
		_on_values_change()

func _process(_delta) -> void:
	# Polling BS technically ok because its just in the editor,
	# But would be better if its event handeled
	#if Engine.is_editor_hint() and bullet_resource:
		#_on_values_change()
	pass
	
func _on_values_change() -> void:
	if not bullet_resource: return
	_on_bullet_type_change()
	_on_bullet_description_change()
	
func _on_bullet_description_change() -> void:
	$description.text = bullet_resource.bullet_description
	
func _on_bullet_type_change() -> void:
	$bullet_frame/icon/Label.visible = false
	match(bullet_resource.bullet_type):
		BulletResource.BulletType.PLAY:
			_on_bullet_type_play()
		BulletResource.BulletType.ACTION:
			_on_bullet_type_action()
		BulletResource.BulletType.SOCIAL:
			_on_bullet_type_social()
		BulletResource.BulletType.PASSIVE:
			_on_bullet_type_passive()
			
func _on_bullet_type_play() -> void:
	$bullet_frame/icon.texture = play_icon
	
func _on_bullet_type_action() -> void:
	$bullet_frame/icon.texture = action_icon
	
func _on_bullet_type_defeat() -> void:
	$bullet_frame/icon.texture = defeat_icon
	
func _on_bullet_type_social() -> void:
	$bullet_frame/icon/Label.text = "%s" % bullet_resource.bullet_cost
	$bullet_frame/icon/Label.visible = true
	$bullet_frame/icon.texture = social_icon
	
func _on_bullet_type_discard() -> void:
	$bullet_frame/icon.texture = discard_icon
	
func _on_bullet_type_passive() -> void:
	$bullet_frame/icon.texture = passive_icon
