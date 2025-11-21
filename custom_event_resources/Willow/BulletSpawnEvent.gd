@tool
extends EventResource
class_name BulletSpawnEvent

@export var player_selects : bool:
	set(value):
		player_selects = value
		notify_property_list_changed()

@export var spawn_positions: Array[Vector2i]
var bullet_template : CardResource = load("res://cards/Willow/Bullet.tres")


const target_card_at: int = 0
#const card_to_place: int = 0
const crazy: float = 2000

func determine_direction(grid_pos: Vector2i) -> Card.CardDirection:
	var direction : Card.CardDirection
	# By default, I'm assuming that any bullets spawn on corners head to the right.
	# This is likely not correct behavior, but 
	var width : int = RiftGrid.Instance.rift_grid_width - 1
	var height : int = RiftGrid.Instance.rift_grid_height - 1
	match grid_pos.y:
		0:
			direction = Card.CardDirection.SOUTH
		height:
			direction = Card.CardDirection.NORTH
	match grid_pos.x:
		0:
			direction = Card.CardDirection.EAST
		width:
			direction = Card.CardDirection.WEST
	return direction

func on_execute() -> bool:
	if player_selects:
		spawn_positions = []
		var selected_pos: Vector2i = m_card_refs[target_card_at].grid_pos
		spawn_positions.append(selected_pos)
	for spawn_pos : Vector2i in spawn_positions:
		var source_card : Card = CardManager.create_card_locally(bullet_template, true)
		source_card.card_dir = determine_direction(spawn_pos)
		match (source_card.card_dir):
			Card.CardDirection.SOUTH:
				source_card.global_position = Vector2(0, crazy)
			Card.CardDirection.NORTH:
				source_card.global_position = Vector2(0, -crazy)
			Card.CardDirection.EAST:
				source_card.global_position = Vector2(-crazy, 0)
			Card.CardDirection.WEST:
				source_card.global_position = Vector2(crazy, 0)
		
		RiftGrid.Instance.place_card(spawn_pos, source_card)
		
		
	return false
	
func required_events() -> Array[EventResource]:
	if not player_selects:
		return []
	var selection: SelectionEventResource = SelectionEventResource.new()
	selection.type = SelectionEventResource.SelectionType.RIFT
	selection.store_at = target_card_at
	selection.filter = RiftCardSelector.Instance.edge_only()
	return [selection]	

func _validate_property(property: Dictionary) -> void:
	var hide_list = []
	if (player_selects):
		hide_list.append("spawn_positions")
		spawn_positions = []
	if property.name in hide_list:
		property.usage = PROPERTY_USAGE_NO_EDITOR
