extends Area2D
class_name DropSlot2D

signal on_drop(dnd_comp: DragAndDropComponent2D)

## Gurantee that a DragAndDropComponent2D is being dropped on this slot!
func drop(dnd_comp: DragAndDropComponent2D) -> void:
	if not dnd_comp: return
	on_drop.emit(dnd_comp)
