@tool
extends CardVisualizer
class_name ClickableCardVisualizer

@export var play_active: bool
@export var interact_active: bool

func _on_bullet_description_change() -> void:
	# Running this more than once is kinda a nightmare ngl
	if not bullet_scene: return
	var bullet_list = $"description_frame/bullet_list"
	if not bullet_list: return
	var child_count: int = bullet_list.get_child_count()
	
	var child_idx: int = 0
	if card_resource.bullets and card_resource.bullets.size() >= 1:
		# No Change needs to be done
		if child_count == card_resource.bullets.size(): return
		
		# Update the changes completly, no incrementals to avoid state issues!
		
		for bullet in card_resource.bullets:
			if not bullet is BulletResource: continue
			
			# Add a new bullet child if you are missing one.
			# (Ryan) Turn this into a pooling mechanism instead!!!
			# Pool around 7 to start with
			if child_idx >= child_count:
				var bullet_node: ClickableBulletVisualizer = bullet_scene.instantiate()
				bullet_node.play_active = play_active
				bullet_node.interact_active = interact_active
				bullet_list.add_child(bullet_node)
				
				# It woudln't add it to the edited scene root without it.
				# But would that work during runtime?
				#if Engine.is_editor_hint():
					#bullet_node.owner = get_tree().edited_scene_root
			
			# Set the bullet node to have the resource, which should update its visual on its own.
			var bullet_visual: ClickableBulletVisualizer = bullet_list.get_child(child_idx)
			if bullet_visual: bullet_visual.bullet_resource = bullet
			child_idx += 1
		
	# Remove extra bullet children
	# (Ryan) Turn this into a pooling mechanism instead!!!
	for j in range(child_idx, child_count):
		bullet_list.get_child(j).queue_free()
