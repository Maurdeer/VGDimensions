extends Node
# Card Manager Script, This is very essential for having constant referencs of all
# Cards and defing their creations here

const CARD = preload("uid://c3e8058lwu0a")

var next_card_id: int = 0
# If a card needs to be freed, this can be changed to a dict.
# I currently do not see a reason for say yet.
var _cards: Dictionary[int, Card]
var _card_resources_dict: Dictionary[String, CardResource]
const card_resources_folder: String = "res://cards/"

func _ready() -> void:
	_load_all_card_resources_from_folder(card_resources_folder)
	
func get_card_by_id(id: int) -> Card:
	return _cards[id]
	
func remove_card_by_id(id: int) -> void:
	rpc("_remove_card_by_id_rpc", id)
	
func create_card(card_resource: CardResource, is_temporary: bool = false) -> Card:
	rpc("_create_card_rpc", card_resource.resource_path, is_temporary)
	return _create_card_rpc(card_resource.resource_path, is_temporary)

func create_cards(card_resources: Array[CardResource]) -> Array[Card]:
	# Serialize card_resources for network
	var card_resource_paths: Array[String]
	for resource in card_resources:
		card_resource_paths.append(resource.resource_path)
	
	# Send them over the network
	rpc("_create_cards_rpc", card_resource_paths)
	
	# Create the cards locally
	return _create_cards_locally(card_resources)
	
func create_cards_from_packs(card_pack_resources: Array[CardPackResource]) -> Array[Card]:
	var crpwa_dict: Dictionary[String, int]
	var crp_dict: Dictionary[CardResource, int]
	for pack in card_pack_resources:
		for card_resource in pack.card_resources:
			if crpwa_dict.has(card_resource.resource_path):
				crp_dict[card_resource] += pack.card_resources[card_resource]
				crpwa_dict[card_resource.resource_path] += pack.card_resources[card_resource]
			else:
				crp_dict[card_resource] = pack.card_resources[card_resource]
				crpwa_dict[card_resource.resource_path] = pack.card_resources[card_resource]
					
	var json = JSON.stringify(crpwa_dict)
	
	rpc("_create_cards_from_pack_rpc", json)
	
	# Create the cards locally
	return _create_cards_from_pack_locally(crp_dict)
	
@rpc("any_peer", "call_local", "reliable")
func _remove_card_by_id_rpc(id: int) -> void:
	if not _cards.has(id): return
	var card: Card = _cards[id]
	_cards.erase(id)
	card.queue_free()
	
@rpc("any_peer", "call_local", "reliable")
func _create_card_rpc(resource_path: String, is_temporary: bool = false) -> Card:
	var resource: CardResource = _card_resources_dict[resource_path]
	var new_card: Card = CARD.instantiate()
	new_card.set_up(next_card_id, resource)
	new_card.temporary = is_temporary
	_cards[next_card_id] = new_card
	next_card_id += 1
	return new_card

@rpc("any_peer", "call_remote", "reliable")
func _create_cards_rpc(card_resource_paths: Array[String]) -> void:
	# Deserialize card_resource_paths to CardResources
	var card_resources: Array[CardResource]
	for path in card_resource_paths:
		card_resources.append(_card_resources_dict[path])
		
	_create_cards_locally(card_resources)

# Prolly a waste of time dude
@rpc("any_peer", "call_remote", "reliable")
func _create_cards_from_pack_rpc(json: String) -> void:
	var crpwa_dict: Dictionary[String, int] = JSON.parse_string(json)
	var crp_dict: Dictionary[CardResource, int]
	
	## Deserialize card_resource_paths to CardResources
	for path in crpwa_dict:
		crp_dict[_card_resources_dict[path]] = crpwa_dict[path]
	
	_create_cards_from_pack_locally(crp_dict)
	
func _create_cards_locally(card_resources: Array[CardResource]) -> Array[Card]:
	if card_resources.is_empty():
		push_warning("No cards were created")
	var new_cards: Array[Card]
	for resource in card_resources:
		var new_card: Card = CARD.instantiate()
		new_card.set_up(next_card_id, resource)
		_cards[next_card_id] = new_card
		new_cards.append(new_card)
		next_card_id += 1
	return new_cards
	
func _create_cards_from_pack_locally(crp_dict: Dictionary[CardResource, int]) -> Array[Card]:
	var new_cards: Array[Card]
	for resource in crp_dict:
		for i in crp_dict[resource]:
			var new_card: Card = CARD.instantiate()
			new_card.set_up(next_card_id, resource)
			_cards[next_card_id] = new_card
			new_cards.append(new_card)
			next_card_id += 1
			
	if new_cards.is_empty():
		push_warning("No cards were created")
	return new_cards
	
	
func _load_all_card_resources_from_folder(path: String) -> void:
	var dir = DirAccess.open(path)
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir(): # Check if its a file and not subdirectory
				_load_all_card_resources_from_folder("%s%s/" % [path, file_name])
			else:
				var file_path: String = path + file_name
				var resource: Resource = load(file_path)
				if not resource is CardResource: continue
				_card_resources_dict[file_path] = resource
				
			file_name = dir.get_next()
				
	else:
		push_error("Where are the card resources bro???")
