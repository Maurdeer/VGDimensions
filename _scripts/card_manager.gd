extends Node
class_name CardManager

# Singleton
static var Instance: CardManager

# User Specific
@export var spawnable_card_3D_scene: PackedScene

# Always Available
@onready var spawner: MultiplayerSpawner = $"../MultiplayerSpawner"

# Private Members
var card_resources: Dictionary[String, Card]

#region Godot Messages
func _ready() -> void:
	# Logic of setting what happens on calling spawn
	#spawner.add_spawnable_scene(spawnable_card_3D_scene.resource_path)
	card_resources = _get_all_card_resources("res://cards/")
	spawner.spawn_function = func(data):
		var card_instance = spawnable_card_3D_scene.instantiate()
		var card_name: String = data[1]
		var card_res: Card = card_resources[card_name]
		#print("ID: %s Spawns %s in client %s. Original data was type: %s" % [data[0], card_res, multiplayer.get_unique_id(), data[1]])
		card_instance.set_multiplayer_authority(data[0])
		(card_instance as CardBoard).card_res = card_res
		(card_instance as CardBoard)._on_place()
		
		return card_instance

func _enter_tree() -> void:
	_singleton_init()

func _singleton_init() -> void:
	if Instance:
		queue_free()
		return
	Instance = self

func _get_all_card_resources(path: String) -> Dictionary[String, Card]:
	# TODO: Determine the id convention of each card on how explicit it should be.
	var dir = DirAccess.open(path)
	var cards: Dictionary[String, Card] = {}
	if not dir: return cards
	dir.list_dir_begin()
	var game_folder_name = dir.get_next()
	while game_folder_name != "":
		if dir.current_is_dir():
			var resources_folder_path = path.path_join("%s/resources" % game_folder_name)
			cards.merge(_get_all_resources_from_game_folder(resources_folder_path))
		game_folder_name = dir.get_next()
	dir.list_dir_end()
	return cards
	
func _get_all_resources_from_game_folder(path: String) -> Dictionary[String, Card]:
	var dir = DirAccess.open(path)
	var cards: Dictionary[String, Card] = {}
	if not dir: return cards
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".tres"):
			var res_path = path.path_join(file_name)
			var card_res = load(res_path)
			if card_res is Card:
				# id creation in runtime:
				var id = "%s" % card_res.name
				cards[id] = card_res
		file_name = dir.get_next()
	dir.list_dir_end()
	return cards

#endregion

func spawn_new_card(card: Card) -> void:
	if multiplayer.is_server():
		_spawn_card(1, card.name)
	else:
		rpc_id(1, "_rpc_spawn_new_card", card.name)

@rpc("any_peer", "call_local", "reliable")
func _rpc_spawn_new_card(card_name: String) -> void:
	if multiplayer.is_server() and multiplayer.get_remote_sender_id() != 1:
		_spawn_card(multiplayer.get_remote_sender_id(), card_name)

func _spawn_card(id: int, card_name: String) -> void:
	if !spawnable_card_3D_scene: return
	var node: Node = spawner.spawn([id, card_name])
