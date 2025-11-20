# @tool
extends Control

@export_group("Wheel Physical Attributes")
@export var wheel_position: Vector2 = Vector2.ZERO
@export var wheel_base_color: Color
# @export var imperception_color: Color
@export var wheel_radius: int = 256
@export var wheel_inner_radius: int = 48
@export var arc_resolution: int = 256

@export_group("Wheel Behavior")
@export var wheel_passive_speed: float = 0.25
@export var do_passive_spin: bool = true
@export var wheel_accel: float = 25
@export var wheel_top_speed: int = 30
# @export var rotation_scale: float = 0.25
# @export var stopping_time: float = 2.0
@export var extra_rotations: int = 10
@export var range_tolerance: float = 0.05

@export_group("Wheel Sector Appearance")
@export var wheel_font: Font
@export var dimension_list: Array[String]
@export var color_list: Array[Color]
@export var font_size: int = 40
@export var outline_size: int = 2

var wheel_radius_midpoint: int = wheel_radius / 2
var wheel_rotation_speed: float = wheel_passive_speed
var do_accel: bool = true
var do_hold: bool = false
var do_slowdown: bool = false
var do_stop_range_calc: bool = false
var target_game: String = ""
var wheel_decel: float = 0

##CALL TO SPIN
func spin_that_wheel(target_dimension: String) -> bool:
	if dimension_list.has(target_dimension):
		target_game = target_dimension
		do_passive_spin = false
		do_accel = true
		return true
	else:
		return false

##WHEEL SELECTOR APPEARANCE SETTINGS
func set_color_list(new_color_list: Array[Color]):
	color_list = new_color_list

func set_dimension_list(new_dimension_list: Array[String]):
	dimension_list = new_dimension_list
	
func set_wheel_font(new_font: Font):
	wheel_font = new_font
	
func set_wheel_font_size(new_font_size: int):
	font_size = new_font_size
	
func set_wheel_font_outline_size(new_font_outline_size: int):
	outline_size = new_font_outline_size
	
##WHEEL PHYSICAL ATTRIBUTE SETTERS
func set_wheel_position(new_pos: Vector2):
	wheel_position = new_pos
	
func set_wheel_radius(new_wheel_radius: int):
	wheel_radius = new_wheel_radius
	
func set_wheel_inner_radius(new_inner_radius: int):
	wheel_inner_radius = new_inner_radius
	
func set_wheel_arc_resolution(new_arc_resolution: int):
	arc_resolution = new_arc_resolution
	
##WHEEL BEHAVIOR SETTORS
func set_wheel_passive_speed(new_passive_speed: float):
	wheel_passive_speed = new_passive_speed
	
func enable_passive_spin():
	do_passive_spin = true
	
func disable_passive_spin():
	do_passive_spin = false
	
func set_wheel_acceleration(new_accel: float):
	wheel_accel = new_accel
	
func set_wheel_top_speed(new_top_speed: int):
	wheel_top_speed = new_top_speed
	
func set_wheel_extra_rotations(new_rotations: int):
	extra_rotations = new_rotations
	
func set_wheel_range_tolerance(new_tolerance: float):
	range_tolerance = new_tolerance








func _draw():
	
	# draw_circle(wheel_position, wheel_radius, wheel_base_color)
	# draw_arc(wheel_position, wheel_radius, 0, TAU, 256, imperception_color)
	if len(dimension_list) > 1:
		for i in range(len(dimension_list)):
			# var angle: float = TAU * i/len(TESTING_dimension_list)
			# var unit_circle_point: Vector2 = Vector2.from_angle(angle)
			# draw_line(wheel_position, unit_circle_point*wheel_radius, imperception_color)
			
			var sector_start_angle: float = TAU * i/len(dimension_list)
			var sector_end_angle: float = TAU * (i+1)/len(dimension_list)
			var sector_mid_angle: float = (sector_start_angle + sector_end_angle) / 2.0
			var sector_range: float = sector_end_angle - sector_start_angle
			var sector_angle_resolution: float = sector_range / arc_resolution
			
			var arc_point_collection: PackedVector2Array = PackedVector2Array()
			for j in range(arc_resolution + 1):
				var intermediate_angle: float = sector_start_angle + j * sector_angle_resolution
				arc_point_collection.append(wheel_radius * Vector2.from_angle(intermediate_angle))
			arc_point_collection.append(wheel_position)
			
			draw_colored_polygon(arc_point_collection, color_list[i % len(color_list)])
			
			draw_set_transform(Vector2.ZERO, sector_mid_angle)
			draw_string(wheel_font, Vector2(((wheel_radius_midpoint-wheel_inner_radius)/2.0) + wheel_inner_radius, 8), dimension_list[i], HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
			draw_string_outline(wheel_font, Vector2(((wheel_radius_midpoint-wheel_inner_radius)/2.0) + wheel_inner_radius, 8), dimension_list[i], HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, outline_size, Color(0,0,0,0.75))
			draw_set_transform(Vector2.ZERO)
	
	draw_circle(wheel_position, wheel_inner_radius + 2, Color(0,0,0,0.75), true, -1, true)
	draw_circle(wheel_position, wheel_inner_radius, Color.WHITE, true, -1, true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if (Input.is_action_just_pressed("ui_accept")):
		#spin_that_wheel("Sleighers")
	#if (Input.is_action_just_pressed("ui_up")):
		#do_passive_spin = true
		#do_accel = true
		#do_hold = false
		#do_slowdown = false
	#if (Input.is_action_just_pressed("ui_down")):
		#do_passive_spin = false
		
	if (do_stop_range_calc):
		var game_index: int = dimension_list.find(target_game)
		var sector_start_angle: float = TAU * game_index/len(dimension_list)
		var sector_end_angle: float = TAU * (game_index+1)/len(dimension_list)
		var sector_range: float = sector_end_angle - sector_start_angle
		var target_stopping_angle: float = randf() * (sector_range - range_tolerance) + sector_start_angle + range_tolerance/2
		var stopping_range: float = TAU - target_stopping_angle
		stopping_range += TAU - rotation
		stopping_range += TAU * (extra_rotations)
		wheel_decel = (wheel_top_speed*wheel_top_speed)/(2*stopping_range)
		do_stop_range_calc = false
		
	if (do_passive_spin):
		wheel_rotation_speed = wheel_passive_speed
	elif (do_accel):
		wheel_rotation_speed += wheel_accel * delta
		if (wheel_rotation_speed > wheel_top_speed):
			wheel_rotation_speed = wheel_top_speed
			do_accel = false
			do_hold = true
	elif (do_hold):
		do_hold = false
		$Timer.start()
	elif (do_slowdown):
		wheel_rotation_speed -= wheel_decel * delta
		if (wheel_rotation_speed <= 0):
			wheel_rotation_speed = 0
			do_slowdown = false
	
	rotation += wheel_rotation_speed * delta
	if (rotation > TAU):
		rotation -= TAU
	# print(rotation)
	
	queue_redraw()
	
func _on_timer_timeout():
	do_slowdown = true
	do_stop_range_calc = true

#func _physics_process(delta):
	#if (do_stop_range_calc):
		#var game_index: int = dimension_list.find(target_game)
		#var sector_start_angle: float = TAU * game_index/len(dimension_list)
		#var sector_end_angle: float = TAU * (game_index+1)/len(dimension_list)
		#var sector_range: float = sector_end_angle - sector_start_angle
		#var target_stopping_angle: float = randf() * (sector_range - range_tolerance) + sector_start_angle + range_tolerance/2
		#var stopping_range: float = TAU - target_stopping_angle
		#stopping_range += TAU - rotation
		#stopping_range += TAU * (extra_rotations)
		#wheel_decel = (wheel_top_speed*wheel_top_speed)/(2*stopping_range)
		#do_stop_range_calc = false
		#
	#if (do_passive_spin):
		#wheel_rotation_speed = wheel_passive_speed
	#elif (do_accel):
		#wheel_rotation_speed += wheel_accel * delta
		#if (wheel_rotation_speed > wheel_top_speed):
			#wheel_rotation_speed = wheel_top_speed
			#do_accel = false
			#do_hold = true
	#elif (do_hold):
		#do_hold = false
		#$Timer.start()
	#elif (do_slowdown):
		#wheel_rotation_speed -= wheel_decel * delta
		#if (wheel_rotation_speed <= 0):
			#wheel_rotation_speed = 0
			#do_slowdown = false
	#
	#rotation += wheel_rotation_speed * delta
	#if (rotation > TAU):
		#rotation -= TAU
	# print(rotation)


# Called when the node enters the scene tree for the first time.
func _ready():
	rotation = 0
	do_passive_spin = true
	$Timer.connect("timeout", _on_timer_timeout)
