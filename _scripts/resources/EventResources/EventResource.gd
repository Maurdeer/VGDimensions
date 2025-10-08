@abstract
extends Resource
class_name EventResource

# TODO: Eventually, add a contextual thing for different points execute can be invoked
# Add an Undo execution functionality for event Resources when undoing changes
# 

# Provide a card_ref into this function
# returns true if succesful, false otherwise
@abstract
func execute(card_ref: Card) -> bool
