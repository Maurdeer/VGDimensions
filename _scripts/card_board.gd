extends Area3D

class_name CardBoard

# User Specifications
@export var card_res: Card

# Predetermined Utilities
@onready var _front_face: MeshInstance3D = $front_quad

func _init(p_card_res: Card = null) -> void:
	card_res = p_card_res

func _on_place() -> void:
	pass
