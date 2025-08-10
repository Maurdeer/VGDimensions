extends Area3D

class_name CardBoard

# User Specifications
@export var card_res: Card

# Predetermined Utilities
@export var _front_face: MeshInstance3D

func _init(p_card_res: Card = null) -> void:
	card_res = p_card_res

func _on_place() -> void:
	_front_face.get_active_material(0).albedo_texture = card_res.card_art
