@abstract
extends Resource
class_name EventResource

# TODO: Eventually, add a contextual thing for different points execute can be invoked
# Add an Undo execution functionality for event Resources when undoing changes
# 
@export var need_required_events: bool = true
var m_card_invoker: Card
var m_card_refs: Dictionary[int, Card]

# Provide a card_ref into this function
# returns true if succesful, false otherwise
func execute(p_card_invoker: Card, p_card_refs: Dictionary[int, Card]) -> bool:
	m_card_invoker = p_card_invoker
	m_card_refs = p_card_refs
	var failure: bool = on_execute()
	return failure

@abstract
func on_execute() -> bool

@abstract
func required_events() -> Array[EventResource]
