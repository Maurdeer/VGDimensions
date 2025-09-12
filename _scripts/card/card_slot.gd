extends Node2D
class_name CardSlot


func _on_drop_slot_component_2d_on_drop(dnd_comp: DragAndDropComponent2D) -> void:
	var dnd_comp_parent: Node2D = dnd_comp.get_parent() 
	if not dnd_comp_parent: return
	dnd_comp_parent.global_position = global_position
