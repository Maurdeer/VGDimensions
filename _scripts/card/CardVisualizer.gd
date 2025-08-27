@tool
extends Node
@onready var card: Card = $".."
var bullet_scene: PackedScene

# Purpose: Provide a seemless way of seeing updates to this node while in the editor.
# without needing to do it during runtime while also not needing to run this functionality
# during runtime.

func _ready() -> void:
	bullet_scene = preload("res://_scenes/card/bullet.tscn")
	if not Engine.is_editor_hint():
		_on_values_change()
		$"../card_front/description_frame/fun_description".text = card.resource.quip_description

func _process(_delta) -> void:
	# Polling BS technically ok because its just in the editor,
	# But would be better if its event handeled
	if Engine.is_editor_hint():
		_on_values_change()
		$"../card_front/description_frame/fun_description".text = card.resource.quip_description
	

func _on_values_change() -> void:
	if not card.resource: return
	
	# Visualization Updates
	call_deferred("_on_title_change")
	call_deferred("_on_game_origin_change")
	call_deferred("_on_card_type_change")
	call_deferred("_on_card_art_change")
	call_deferred("_on_effector_bools_change")
	
	# Value TAB updates
	call_deferred("_on_starting_hp_change")
	call_deferred("_on_deleon_value_change")
	
	# Bullet Description Updates:
	#call_deferred("_on_bullet_description_change")
	
func _on_title_change() -> void:
	var title_label = $"../card_front/title_frame/Label"
	if not title_label: return
	title_label.text = card.resource.title
	
func _on_game_origin_change() -> void:
	var game_origin_label = $"../card_front/typing_frame/game_origin_label"
	if not game_origin_label: return
	game_origin_label.text = CardResource.GameOrigin.keys()[card.resource.game_origin].capitalize()
	
func _on_card_type_change() -> void:
	var card_type_label = $"../card_front/typing_frame/type_label"
	if not card_type_label: return
	card_type_label.text = CardResource.CardType.keys()[card.resource.type].capitalize()
	
func _on_card_art_change() -> void:
	var card_art = $"../card_front/card_art_container/card_art"
	if not card_art: return
	card_art.texture = card.resource.card_art
	
func _on_starting_hp_change() -> void:
	var health_value_frame = $"../card_front/HBoxContainer/health_value_frame"
	var health_value_label = $"../card_front/HBoxContainer/health_value_frame/TextureRect/Label2"
	if not health_value_frame or not health_value_label: return
	health_value_frame.visible = card.resource.starting_hp >= 0
	health_value_label.text = "%s" % card.resource.starting_hp
	
func _on_deleon_value_change() -> void:
	var deleon_value_frame = $"../card_front/HBoxContainer/deleon_value_frame"
	var deleon_value_label = $"../card_front/HBoxContainer/deleon_value_frame/TextureRect/Label"
	if not deleon_value_frame or not deleon_value_label: return
	deleon_value_label.text = "%s" % card.resource.deleon_value
	deleon_value_frame.visible = card.resource.deleon_value >= 0
		
func _on_effector_bools_change() -> void:
	$"../card_front/Effectors/not_movable_frame".visible = not card.resource.movable
	$"../card_front/Effectors/not_burnable_frame".visible = not card.resource.burnable
	$"../card_front/Effectors/not_stackable_frame".visible = not card.resource.stackable
	$"../card_front/Effectors/not_discardable_frame".visible = not card.resource.discardable
	$"../card_front/Effectors/not_flippable_frame".visible = not card.resource.flippable
	$"../card_front/Effectors/not_stunnable_frame2".visible = not card.resource.stunnable
	$"../card_front/Effectors/refreshable_frame".visible = card.resource.refreshable
	
func _on_bullet_description_change() -> void:
	# Running this more than once is kinda a nightmare ngl
	var bullet_list = $"../card_front/description_frame/bullet_list"
	var child_count: int = bullet_list.get_child_count()
	if not bullet_list: return
		
	var child_idx: int = 0
	for bullet in card.resource.bullets:
		if not bullet is BulletResource: continue
		if child_idx >= child_count:
			var bullet_node = card.resource.bullet_scene.instantiate()
			bullet_list.add_child(bullet_node)
			if Engine.is_editor_hint():
				bullet_node.owner = get_tree().edited_scene_root
		(bullet_list.get_child(child_idx) as Bullet).bullet_resource = bullet
		child_idx += 1
		
	# Remove extra bullet children
	for j in range(child_idx, child_count):
		bullet_list.get_child(j).queue_free()
	
func _notification(what: int) -> void:
	if what == NOTIFICATION_EDITOR_POST_SAVE:
		_on_values_change()
