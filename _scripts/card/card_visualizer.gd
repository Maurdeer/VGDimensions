@tool
extends Sprite2D
class_name CardVisualizer

## Purpose: Provide a seemless way of seeing updates to this node while in the editor.
## without needing to do it during runtime while also not needing to run this functionality
## during runtime.

# Exists to deal with editor based card updating
@export var card: Card
@export var card_resource: CardResource:
	get:
		if card:
			return card.resource
		return card_resource
	set(value):
		card_resource = value
		_on_values_change()

@export var bullet_scene: PackedScene
@onready var icons: VBoxContainer = $GUI/Icons


func _ready() -> void:
	if not bullet_scene:
		printerr("Bullet Scene was not intialized with a bullet visualizer! CardVisualizer will not run!")
		return
	if not Engine.is_editor_hint() and (card_resource or (card and card.resource)):
		_on_values_change()

func _process(_delta) -> void:
	# Polling BS technically ok because its just in the editor,
	# But would be better if its event handeled
	if Engine.is_editor_hint() and (card_resource or (card and card.resource)):
		_on_values_change()

func _on_values_change() -> void:
	if not card_resource: return
	
	# Visualization Updates
	call_deferred("_on_title_change")
	call_deferred("_on_game_origin_change")
	call_deferred("_on_card_type_change")
	call_deferred("_on_card_art_change")
	call_deferred("_on_effector_bools_change")
	call_deferred("_on_background_art_change")
	
	# Value TAB updates
	call_deferred("_on_starting_hp_change")
	call_deferred("_on_deleon_value_change")
	
	# Bullet Description Updates:
	call_deferred("_on_bullet_description_change")
	call_deferred("_on_texture_list_change")
	call_deferred("_on_funny_quip_change")
	
func _on_title_change() -> void:
	var title_label = $"title_frame/Label"
	if not title_label: return
	title_label.text = card_resource.title
	
func _on_game_origin_change() -> void:
	var game_origin_label = $"typing_frame/game_origin_label"
	if not game_origin_label: return
	game_origin_label.text = CardResource.GameOrigin.keys()[card_resource.game_origin].capitalize()
	
func _on_card_type_change() -> void:
	var card_type_label = $"typing_frame/type_label"
	if not card_type_label: return
	card_type_label.text = CardResource.CardType.keys()[card_resource.type].capitalize()
	
func _on_card_art_change() -> void:
	var card_art = $"card_art_container/card_art"
	if not card_art: return
	card_art.texture = card_resource.card_art
	
func _on_starting_hp_change() -> void:
	var health_value_frame = $"HBoxContainer/health_value_frame"
	var health_value_label = $"HBoxContainer/health_value_frame/TextureRect/Label2"
	if not health_value_frame or not health_value_label: return
	health_value_frame.visible = card_resource.starting_hp >= 0
	health_value_label.text = "%s" % card_resource.starting_hp
	
func _on_deleon_value_change() -> void:
	var deleon_value_frame = $"HBoxContainer/deleon_value_frame"
	var deleon_value_label = $"HBoxContainer/deleon_value_frame/TextureRect/Label"
	if deleon_value_frame and deleon_value_label: 
		deleon_value_label.text = "%s" % card_resource.deleon_value
		deleon_value_frame.visible = card_resource.deleon_value >= 0
	var deleon_badge_icon = $GUI/Icons/deleon
	var deleon_badge_label = $GUI/Icons/deleon/Label
	if deleon_badge_icon and deleon_badge_label:
		deleon_badge_label.text = "%s" % card_resource.deleon_value
		deleon_badge_icon.visible = card_resource.deleon_value >= 0
		
func _on_effector_bools_change() -> void:
	$"Effectors/not_movable_frame".visible = not card_resource.movable
	$"Effectors/not_burnable_frame".visible = not card_resource.burnable
	$"Effectors/not_stackable_frame".visible = not card_resource.stackable
	$"Effectors/not_discardable_frame".visible = not card_resource.discardable
	$"Effectors/not_flippable_frame".visible = not card_resource.flippable
	$"Effectors/not_stunnable_frame2".visible = not card_resource.stunnable
	$"Effectors/refreshable_frame".visible = card_resource.refreshable
	
func _on_background_art_change() -> void:
	$card_background/nestedImage.texture = card_resource.background_art
	
func _on_bullet_description_change() -> void:
	# TODO: Optimize Bullets to be pooled intead of created and destroyed everytime
	# Running this more than once is kinda a nightmare ngl
	if not bullet_scene: return
	var bullet_list = $description_frame/DescriptorContainer/bullet_list
	if not bullet_list: return
	var child_count: int = bullet_list.get_child_count()
	
	# If no bullets, remove children
	if not card_resource.bullets:
		for j in child_count:
			bullet_list.get_child(j).queue_free()
		return
	
	# If we need more children for the list add them
	while child_count < card_resource.bullets.size():
		var bullet_node = bullet_scene.instantiate()
		bullet_list.add_child(bullet_node)
		
		if Engine.is_editor_hint():
			bullet_node.owner = get_tree().edited_scene_root
		child_count += 1
		
	# Remove extra bullet children
	# (Ryan) Turn this into a pooling mechanism instead!!!
	for j in range(card_resource.bullets.size(), child_count):
		bullet_list.get_child(j).queue_free()
		
	# Update Each Bullets Visual
	var i: int = 0
	for bullet in card_resource.bullets:
		var bullet_child: Node  = bullet_list.get_child(i)
		assert(bullet_child is BulletVisualizer, "How the Fuck?")
		bullet_child.bullet_resource = bullet
		i += 1
		
func _on_texture_list_change() -> void:
	var texture_list = $description_frame/DescriptorContainer/texture_list
	if not texture_list: return
	for child in texture_list.get_children(true): child.queue_free()
	if card_resource.description_textures.is_empty(): return
	for desc_texture in card_resource.description_textures:
		var rect_texture: TextureRect = TextureRect.new()
		texture_list.add_child(rect_texture)
		rect_texture.texture = desc_texture
		rect_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	
func _on_funny_quip_change() -> void:
	var funny_quip = $description_frame/DescriptorContainer/fun_quip
	if not funny_quip: return
	funny_quip.text = "\"%s\"" % card_resource.quip_description
func _notification(what: int) -> void:
	if what == NOTIFICATION_EDITOR_POST_SAVE:
		_on_values_change()

func dissolve_shader() -> bool:
	var timer = 1
	while timer <= 5:
		material.set_shader_parameter("dissolve_amount", 0.2 * timer)
		await get_tree().create_timer(0.1).timeout
		timer += 1
	return true
	
	
