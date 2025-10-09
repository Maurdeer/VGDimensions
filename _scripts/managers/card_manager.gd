extends Node
# Card Manager Script, This is very essential for having constant referencs of all
# Cards and defing their creations here

const CARD = preload("uid://c3e8058lwu0a")

var next_card_id: int = 0
# If a card needs to be freed, this can be changed to a dict.
# I currently do not see a reason for say yet.
var _cards: Array[Card]
var _card_resources_dict: Dictionary[String, CardResource]
const card_resources_folder: String = "res://cards/"

func _ready() -> void:
	_load_all_card_resources_from_folder(card_resources_folder)
	
func get_card_by_id(id: int) -> Card:
	return _cards[id]
	
func remove_card_by_id(id: int) -> void:
	_remove_card_by_id_rpc.rpc(id)

signal create_card_ack
func create_card(card_resource: CardResource, is_temporary: bool = false) -> Card:
	_create_card_rpc.rpc(card_resource.resource_path, is_temporary)
	var card: Card = _create_card_rpc(card_resource.resource_path, is_temporary)
	
	# Prolly need to change to account for multiple clients
	await create_card_ack
	return card

func create_cards(card_resources: Array[CardResource]) -> Array[Card]:
	# Serialize card_resources for network
	var card_resource_paths: Array[String]
	for resource in card_resources:
		card_resource_paths.push_back(resource.resource_path)
	
	# Send them over the network
	_create_cards_rpc.rpc(card_resource_paths)
	
	# Create the cards locally
	return _create_cards_locally(card_resources)
	
func create_cards_from_packs(card_pack_resources: Array[CardPackResource]) -> Array[Card]:
	# Unsafe due to Dictionaries not preserving order
	#var crpwa_dict: Dictionary[String, int]
	#var crp_dict: Dictionary[CardResource, int]
	#for pack in card_pack_resources:
		#for card_resource in pack.card_resources:
			#if crpwa_dict.has(card_resource.resource_path):
				#crp_dict[card_resource] += pack.card_resources[card_resource]
				#crpwa_dict[card_resource.resource_path] += pack.card_resources[card_resource]
			#else:
				#crp_dict[card_resource] = pack.card_resources[card_resource]
				#crpwa_dict[card_resource.resource_path] = pack.card_resources[card_resource]
					#
	#var json = JSON.stringify(crpwa_dict)
	
	var card_resource_paths: Array[String]
	var card_resources: Array[CardResource]
	for pack in card_pack_resources:
		for card_resource in pack.card_resources:
			for amount in pack.card_resources[card_resource]:
				card_resource_paths.push_back(card_resource.resource_path)
				card_resources.push_back(card_resource)
				
	
	_create_cards_rpc.rpc(card_resource_paths)
	
	# Create the cards locally
	return _create_cards_locally(card_resources)
	
@rpc("any_peer", "call_local", "reliable")
func _remove_card_by_id_rpc(id: int) -> void:
	if not _cards.has(id): return
	_cards[id].queue_free() # Intentional to keep the position null 
	# TODO: Create future function that can deal with this occurence
	# And update all the card_ids according to a freed element
	# This should be done when we reach a certain threshold of removing cards
	# rather than doing it everytime we remove a card.
	
@rpc("any_peer", "call_local", "reliable")
func _create_card_rpc(resource_path: String, is_temporary: bool = false) -> Card:
	var resource: CardResource = _card_resources_dict[resource_path]
	var new_card: Card = CARD.instantiate()
	new_card.set_up(next_card_id, resource)
	new_card.temporary = is_temporary
	_cards.push_back(new_card)
	next_card_id += 1
	_acknowledge_create_card.rpc()
	return new_card

@rpc("any_peer", "call_remote", "reliable")
func _acknowledge_create_card():
	create_card_ack.emit()

@rpc("any_peer", "call_remote", "reliable")
func _create_cards_rpc(card_resource_paths: Array[String]) -> void:
	# Deserialize card_resource_paths to CardResources
	var card_resources: Array[CardResource]
	for path in card_resource_paths:
		card_resources.push_back(_card_resources_dict[path])
		
	_create_cards_locally(card_resources)

# Prolly a waste of time dude
@rpc("any_peer", "call_remote", "reliable")
func _create_cards_from_pack_rpc(json: String) -> void:
	var crpwa_dict = JSON.parse_string(json) as Dictionary[String, int]
	var crp_dict: Dictionary[CardResource, int]
	
	## Deserialize card_resource_paths to CardResources
	for path in crpwa_dict:
		crp_dict[_card_resources_dict[path]] = (crpwa_dict[path] as int)
	
	_create_cards_from_pack_locally(crp_dict)
	
func _create_cards_locally(card_resources: Array[CardResource]) -> Array[Card]:
	if card_resources.is_empty():
		push_warning("No cards were created")
	var new_cards: Array[Card]
	for resource in card_resources:
		var new_card: Card = CARD.instantiate()
		new_card.set_up(next_card_id, resource)
		_cards.push_back(new_card)
		new_cards.push_back(new_card)
		next_card_id += 1
	return new_cards
	
func _create_cards_from_pack_locally(crp_dict: Dictionary[CardResource, int]) -> Array[Card]:
	var new_cards: Array[Card]
	for resource in crp_dict:
		for i in crp_dict[resource]:
			var new_card: Card = CARD.instantiate()
			new_card.set_up(next_card_id, resource)
			_cards.push_back(new_card)
			new_cards.push_back(new_card)
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
		
func cards_to_ids(cards: Array[Card]) -> Array[int]:
	var card_ids: Array[int]
	for card in cards:
		card_ids.push_back(card.card_id)
	return card_ids
	
func ids_to_cards(card_ids: Array[int]) -> Array[Card]:
	var cards: Array[Card]
	for id in card_ids:
		cards.push_back(_cards[id])
	return cards
	
# Security Check
func validate_cards() -> void:
	var card_names_compare: Dictionary[int, String]
	for id in _cards.size():
		card_names_compare[id] = _cards[id].resource.title
		
	var json = JSON.stringify(card_names_compare)
	validate_ids.rpc(json)

@rpc("any_peer", "call_remote", "reliable")
func validate_ids(json: String) -> void:
	var card_names_compare: Dictionary = JSON.parse_string(json)
	for id in card_names_compare:
		assert(_cards[id as int].resource.title == card_names_compare[id as int], "id %s did not match" % id)
