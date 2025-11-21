extends Control
class_name WheelSubContainer

@export var descent_speed: int = 250
var initial_pos: Vector2
var ascend_pos: Vector2
@onready var wheel: TheWheel = $Wheel
var spinning: bool = false
var start_spin: bool = false
var ascending: bool = false
var select_dimension: String
# Called when the node enters the scene tree for the first time.
func _ready():
	initial_pos = position
	ascend_pos = initial_pos + Vector2.UP * 2000
	pass
	#initial_pos = position
	#reset_wheel()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not start_spin: 
		if ascending:
			if (position.y > ascend_pos.y):
				position = position.move_toward(ascend_pos, descent_speed * delta)
			else:
				ascending = false
		return
	if spinning:
		if wheel.wheel_rotation_speed <= 0:
			spinning = false
			start_spin = false
		return
	if (position.y < initial_pos.y):
		position = position.move_toward(initial_pos, descent_speed * delta)
	elif not spinning:
		position = initial_pos
		wheel.spin_that_wheel(select_dimension)
		spinning = true
		
func ascend() -> void:
	position = initial_pos
	ascending = true
		
func reset_wheel(dim_name: String) -> void:
	select_dimension = dim_name
	position = ascend_pos
	start_spin = true
