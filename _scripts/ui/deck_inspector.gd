extends Control
class_name DeckInspector

@onready var card_container: GridContainer = $GridContainer 
@onready var background: ColorRect = $ColorRect

const CARD = preload("uid://c3e8058lwu0a")


func view_deck(deck_to_inspect: Deck) -> void:
	visible = true
	
	for child in card_container.get_children():
		child.queue_free()
		
	for card_data in deck_to_inspect.deck_array:
		var card_visual = CARD.instantiate()
		
		card_visual.set_up(-1, card_data.resource)
		
		var card_slot_wrapper = Control.new()
		card_slot_wrapper.name = "CardSlot_" + str(card_container.get_child_count())
		card_slot_wrapper.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		card_slot_wrapper.size_flags_horizontal = 0 
		card_slot_wrapper.size_flags_horizontal |= Control.SIZE_SHRINK_CENTER
		card_slot_wrapper.size_flags_horizontal |= Control.SIZE_EXPAND
		
		card_slot_wrapper.size_flags_vertical = 0
		card_slot_wrapper.size_flags_vertical |= Control.SIZE_SHRINK_CENTER
		card_slot_wrapper.size_flags_vertical |= Control.SIZE_EXPAND
		
		card_slot_wrapper.add_child(card_visual)
		card_container.add_child(card_slot_wrapper)

		card_visual.card_sm.transition_to_state(CardStateMachine.StateType.IN_DECK)

func close_deck_inspector(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
	print("attempted to close deck")
	var mouse_event: InputEventMouseButton = event
	
	if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
		print("deck closed")
		hide_view()
		
func hide_view() -> void:
	visible = false
	
	# Clean up the children appended to GridContainer
	for child in card_container.get_children():
		child.queue_free()
		


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
