extends Node
class_name CardManager

@export var spawnable_card_3D_scene: PackedScene
static var Instance: CardManager
@onready var spawner: MultiplayerSpawner = $"../MultiplayerSpawner"

@rpc("any_peer", "call_local", "reliable")
func spawn_new_card(data) -> void:
	if !multiplayer.is_server(): return
	if spawnable_card_3D_scene:
		# Recall getting the data form local or remote
		var card_res: Card
		if data["card_res"] is Card: 
			card_res = data["card_res"]
		elif data["card_res"] is EncodedObjectAsID: 
			card_res = instance_from_id(data["card_res"].object_id)
		var node: Node = spawner.spawn([multiplayer.get_remote_sender_id(), card_res])

func _ready() -> void:
	# Logic of setting what happens on calling spawn
	#spawner.add_spawnable_scene(spawnable_card_3D_scene.resource_path)
	spawner.spawn_function = func(data):
		print("Attempting to spawn")
		var card_instance = spawnable_card_3D_scene.instantiate()
		(card_instance as CardBoard).card_res = data[1]
		(card_instance as CardBoard)._on_place()
		card_instance.set_multiplayer_authority(data[0])
		return card_instance

func _enter_tree() -> void:
	_singleton_init()

func _singleton_init() -> void:
	if Instance:
		queue_free()
		return
	Instance = self
