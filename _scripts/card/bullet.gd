@tool
extends HBoxContainer
class_name Bullet

var bullet_resource: BulletResource:
	set(value):
		bullet_resource = value
		call_deferred("_on_value_change")
	
func _on_value_change() -> void:
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
	
