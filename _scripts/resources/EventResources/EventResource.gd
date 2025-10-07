@abstract
extends Resource
class_name EventResource

# Provide a card_ref into this function
# returns true if succesful, false otherwise
@abstract
func execute(card_ref: Card) -> bool
