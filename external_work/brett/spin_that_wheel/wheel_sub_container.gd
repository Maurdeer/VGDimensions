extends Control

@export var descent_speed: int = 250
var initial_pos: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	initial_pos = position
	position = initial_pos + Vector2.UP * 2000


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (position.y < initial_pos.y):
		position -= Vector2.UP * descent_speed * delta
	else:
		position = initial_pos
