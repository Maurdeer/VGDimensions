extends Area3D

# The physical card on the field, extending this card can specify the differences on how it can
# Effect the field.
class_name CardBoard


# User Specifications
@export var card_res: Card

# Predetermined Utilities
@export var _front_face: MeshInstance3D

func _init(p_card_res: Card = null) -> void:
	card_res = p_card_res

func _on_place() -> void:
	var material = _front_face.get_active_material(0)
	if material:
		material = material.duplicate()
		_front_face.set_surface_override_material(0, material)
		material.albedo_texture = card_res.front_texture
