extends Control

@export var TheWheel: Node
@export var arrow_overlap: int = 10
@export var arrow_length: int
@export var arrow_height: int
var triangle_points: PackedVector2Array
var triangle_color: PackedColorArray
var triangle2_points: PackedVector2Array
var triangle2_color: PackedColorArray
var arrow_offset: Vector2
func _draw():
	# draw_line(Vector2.ZERO, Vector2.RIGHT*TheWheel.wheel_radius - Vector2(arrow_overlap, 0), Color.DARK_RED)
	draw_polygon(triangle2_points, triangle2_color)
	draw_polygon(triangle_points, triangle_color)



# Called when the node enters the scene tree for the first time.
func _ready():
	arrow_offset = Vector2.RIGHT*TheWheel.wheel_radius - Vector2(arrow_overlap, 0)
	arrow_length = arrow_overlap + 30
	arrow_height = 20
	triangle_points = PackedVector2Array()
	triangle_points.append(Vector2.ZERO + arrow_offset)
	triangle_points.append(Vector2(arrow_length, arrow_height) + arrow_offset)
	triangle_points.append(Vector2(arrow_length,-arrow_height) + arrow_offset)
	
	triangle_color = PackedColorArray()
	triangle_color.append(Color.WHITE)
	
	triangle2_points = PackedVector2Array()
	triangle2_points.append(Vector2.ZERO + arrow_offset - Vector2.RIGHT*5)
	triangle2_points.append(Vector2(arrow_length + 2, arrow_height + 3) + arrow_offset)
	triangle2_points.append(Vector2(arrow_length + 2,-arrow_height - 3) + arrow_offset)
	
	triangle2_color = PackedColorArray()
	triangle2_color.append(Color.BLACK)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	queue_redraw()
