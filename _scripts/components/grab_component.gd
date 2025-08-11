extends Node
class_name GrabComponent

@onready var parent: Node3D = $".."
@export var _flip_component: FlipComponent
const RAY_LENGTH = 1000

var _grabbing: bool = false

# (Ryan) Temporary input testing function
# Remove later when input system gets implemented
func _input(event):
	if not is_multiplayer_authority(): return
	var casted = ray_cast()
	if casted == parent and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		_grabbing = event.is_pressed()	

func _process(delta):
	_input_process()

	
func _input_process() -> void:
	if _grabbing: 
		follow_mouse()
		if Input.is_action_just_pressed("flip"):
			_flip_component.flip()

func follow_mouse():
	var mouse_position = get_viewport().get_mouse_position()
	var camera = get_viewport().get_camera_3d()
	var origin = camera.project_ray_origin(mouse_position)
	var end = camera.project_ray_normal(mouse_position)
	var depth = origin.distance_to(parent.global_position)
	var final_position = origin + end * depth
	parent.global_position = final_position
	
func ray_cast():
	var space_state = parent.get_world_3d().direct_space_state
	var camera = get_viewport().get_camera_3d()
	var mouse_position = get_viewport().get_mouse_position()
	var origin = camera.project_ray_origin(mouse_position)
	var end = origin + camera.project_ray_normal(mouse_position) * RAY_LENGTH
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = true
	var result = space_state.intersect_ray(query)
	result = result.get("collider")
	return result
