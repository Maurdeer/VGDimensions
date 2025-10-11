@abstract
extends Resource
class_name EventResource

# TODO: Eventually, add a contextual thing for different points execute can be invoked
# Add an Undo execution functionality for event Resources when undoing changes
# 
var m_card_invoker: Card

# Provide a card_ref into this function
# returns true if succesful, false otherwise
func execute(p_card_invoker: Card) -> bool:
	m_card_invoker = p_card_invoker
	var failure: bool = on_execute()
	return failure

@abstract
func on_execute() -> bool
