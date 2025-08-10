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
		# ====This is the syntax for determining the difference====
		var card_res: Card
		if data["card_res"] is Card: 
			card_res = data["card_res"]
		elif data["card_res"] is EncodedObjectAsID: 
			card_res = instance_from_id(data["card_res"].object_id)
		#==========================================================
		var node: Node = spawner.spawn([multiplayer.get_remote_sender_id(), card_res])

func _ready() -> void:
	# Logic of setting what happens on calling spawn
	#spawner.add_spawnable_scene(spawnable_card_3D_scene.resource_path)
	spawner.spawn_function = func(data):
		var card_instance = spawnable_card_3D_scene.instantiate()
		
		# ====This is the syntax for determining the difference====
		# Reason its here too: When the object spawns it will use this function on every peer, thus
		# the current peer that calls this will have the local data but everyone else will get it encodded, so
		# we have to decode it still.
		var card_res: Card
		if data[1] is Card: 
			# Local Call
			card_res = data[1]
		elif data[1] is EncodedObjectAsID:
			# Decode Remote Encoded Object 
			card_res = instance_from_id(data[1].object_id)
		#==========================================================
		print("ID: %s Spawns %s in client %s. Original data was type: %s" % [data[0], card_res, multiplayer.get_unique_id(), data[1]])
		card_instance.set_multiplayer_authority(data[0])
		if (card_instance as CardBoard).card_res:
			(card_instance as CardBoard).card_res.card_art = card_res.card_art
		else:
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
