extends Node
class_name FlipComponent

@onready var parent: Node3D = $".."

func flip() -> void:
	parent.rotate(Vector3(0, 0, 1), 180)
