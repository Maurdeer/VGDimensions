extends Control
class_name PlayerHand

static var Instance: PlayerHand

const hand_limit: int = 20
const hand_draw_limit: int = 5
@export var discard_pile: Deck
@export var draw_pile: Deck
@export var deck_inspector: Control
@onready var slots: HBoxContainer = $hand_region/Slots
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var draw_pile_size_label: Label = $NinePatchRect2/HBoxContainer/VBoxContainer2/DrawPile/Label
@onready var discard_pile_size_label: Label = $NinePatchRect2/HBoxContainer/VBoxContainer/DiscardPile/Label2

var empty_card: Card
var slot_queue: Array[Control]

var cards_in_hand: Dictionary[Card, Control] = {}

func _ready() -> void:
	if Instance: 
		queue_free()
		return
	Instance = self
	
	# Clear Prexisting stuff in this
	for child in slots.get_children():
		child.queue_free()
	
	for i in range(hand_limit):
		var slot: Control = Control.new()
		slot.mouse_filter = Control.MOUSE_FILTER_PASS
		slot.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		slot.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		slot_queue.append(slot)
	call_deferred("_after_ready")
	
func _after_ready() -> void:
	pass
	
func clear_hand() -> void:
	for card in cards_in_hand.keys():
		discard_card(card)
	
func fill_hand() -> void:
	var added_count: int = 0
	while added_count < hand_draw_limit and not slot_queue.is_empty():
		if draw_card_to_hand():
			break
		added_count += 1

# not used yet (use with caution)
func add_card_to_hand(card: Card) -> void:
	var slot: Control = slot_queue.pop_back()
	if slot == null:
		return
	card.grid_pos = Vector2i(-1, -1)
	card.player_owner = "Player"
	if card.get_parent():
		card.get_parent().remove_child(card)
	card.card_sm.transition_to_state(CardStateMachine.StateType.IN_HAND)
	
	slot.add_child(card)
	slots.add_child(slot)
	card.flip_reveal()
	cards_in_hand[card] = slot

func draw_card_to_hand() -> bool:
	if slot_queue.is_empty(): return true
	if draw_pile.is_empty(): reshuffle_draw_pile()
	if draw_pile.is_empty(): return true
	
	# Retrieve the card
	var card: Card = draw_pile.remove_top_card()
	draw_pile_size_label.text = "%s" % draw_pile.deck_size
	card.grid_pos = Vector2i(-1, -1)
	card.owner_pid = multiplayer.get_unique_id() # When we add netcoding do this -> GNM.player_info['name']
	card.card_sm.transition_to_state(CardStateMachine.StateType.IN_HAND)
	
	# =================I'm not a big fan of this====================
	# TODO: Vortex code might change this hopefully?
	#var on_played: Callable
	#match(card.resource.type):
		#CardResource.CardType.FEATURE:
			#on_played = discard_card
		#CardResource.CardType.ALLY:
			#on_played = discard_card
		#CardResource.CardType.ASSET:
			#on_played = remove_card_from_hand
			#
	#if on_played: card.played.connect(on_played)
	# ===============================================================
	# Acquire a slot from the slot queue to hold the card
	var slot: Control = slot_queue.pop_back()
	slot.add_child(card)
	card.position = Vector2.ZERO
	slots.add_child(slot)
	
	# When card in tree do the following:
	card.flip_reveal()
	
	cards_in_hand[card] = slot
	return false
	
func reshuffle_draw_pile() -> void:
	draw_pile.mergeDeck(discard_pile)
	draw_pile_size_label.text = "%s" % draw_pile.deck_size
	discard_pile_size_label.text = "%s" % discard_pile.deck_size
	draw_pile.shuffleDeck()
	
# adds to discard pile ONLY
func add_to_discard(card: Card) -> void:
	card.grid_pos = Vector2i(-1, -1)
	discard_pile.addCard(card)
	discard_pile_size_label.text = "%s" % discard_pile.deck_size
	card.card_sm.transition_to_state(CardStateMachine.StateType.UNDEFINED)
	
func add_to_draw_pile(card: Card) -> void:
	card.grid_pos = Vector2i(-1, -1)
	draw_pile.add_card_under(card)
	draw_pile_size_label.text = "%s" % draw_pile.deck_size
	card.card_sm.transition_to_state(CardStateMachine.StateType.UNDEFINED)
	
func discard_card(card: Card) -> void:
	remove_card_from_hand(card)
	card.grid_pos = Vector2i(-1, -1)
	discard_pile.addCard(card)
	discard_pile_size_label.text = "%s" % discard_pile.deck_size
	card.card_sm.transition_to_state(CardStateMachine.StateType.UNDEFINED)
	
func remove_card_from_hand(card: Card) -> void:
	if not cards_in_hand.has(card): return
	if card.played.is_connected(discard_card): card.played.disconnect(discard_card)
	if card.get_parent() == cards_in_hand[card]: cards_in_hand[card].remove_child(card)
	slots.remove_child(cards_in_hand[card])
	slot_queue.append(cards_in_hand[card])
	cards_in_hand.erase(card)
	
func disable_player_hand() -> void:
	for card in cards_in_hand:
		card.card_sm.transition_to_state(CardStateMachine.StateType.UNSELECTABLE)
		
func enable_player_hand() -> void:
	for card in cards_in_hand:
		card.card_sm.transition_to_state(CardStateMachine.StateType.INTERACTABLE)

func _on_hand_region_mouse_entered() -> void:
	animation_player.play("show")


func _on_hand_region_mouse_exited() -> void:
	animation_player.play("show", -1, -1.0, true)

# move this method to deck class if we want this view for ANY deck
func _on_control_gui_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton: return
	var mouse_event: InputEventMouseButton = event
	
	if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.is_pressed():
		if not deck_inspector:
			printerr("PlayerHand ERROR: A deck_inspector node is needed to view the discard pile.")
			return 
		if discard_pile.is_empty():
			print("Discard Pile is empty. Cannot open deck inspector.")
			return
		deck_inspector.visible = true
		deck_inspector.view_deck(discard_pile)
