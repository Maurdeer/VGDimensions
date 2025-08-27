@tool
extends HBoxContainer
class_name BulletVisualizer

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
	if Engine.is_editor_hint() and bullet_resource:
		_on_values_change()
	
func _on_values_change() -> void:
	$bullet_frame/icon/Label.visible = false
	match(bullet_resource.bullet_type):
		BulletResource.BulletType.PLAY:
			$bullet_frame/icon.texture = load("res://art/card_ui/play.png")
		BulletResource.BulletType.ACTION:
			$bullet_frame/icon.texture = load("res://art/card_ui/action.png")
		BulletResource.BulletType.DEFEAT:
			$bullet_frame/icon.texture = load("res://art/card_ui/damage.png")
		BulletResource.BulletType.SOCIAL:
			$bullet_frame/icon/Label.text = "%s" % bullet_resource.bullet_cost
			$bullet_frame/icon/Label.visible = true
			$bullet_frame/icon.texture = load("res://art/card_ui/social.png")
		BulletResource.BulletType.DISCARD:
			$bullet_frame/icon.texture = load("res://art/card_ui/damage.png")
		BulletResource.BulletType.PASSIVE:
			$bullet_frame/icon.texture = load("res://art/card_ui/passive.png")
			
	$description.text = bullet_resource.bullet_description
	
