extends Node
class_name DeckInspector

@onready var card_container: GridContainer = $GridContainer 
@onready var background: ColorRect = $ColorRect

const CARD = preload("uid://c3e8058lwu0a")


func view_deck(deck_to_inspect: Deck) -> void:
	for child in card_container.get_children():
		child.queue_free()
		
	for card_data in deck_to_inspect.deck_array:
		var card_visual = CARD.instantiate()
		
		card_visual.set_up(-1, card_data.resource)
		card_visual.flip_reveal() 
		
		#card_visual.gridcard_visualizer.visible = false
		#card_visual.gridcard_back.visible = false
		#card_visual.gridcard_shape.disabled = true
		
		#card_visual.card_visualizer.visible = true
		#card_visual.card_back.visible = true
		#card_visual.card_shape.disabled = false
		
		var card_slot_wrapper = Control.new()
		card_slot_wrapper.name = "CardSlot_" + str(card_container.get_child_count())
		
		card_slot_wrapper.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		card_slot_wrapper.size_flags_vertical = Control.SIZE_EXPAND_FILL
		
		card_slot_wrapper.add_child(card_visual)
		card_container.add_child(card_slot_wrapper)
		#card_visual.card_visualizer.visible = true

		#card_visual.card_sm.transition_to_state(CardStateMachine.StateType.IN_DECK)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
