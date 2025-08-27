extends Resource
class_name EventResource

var card_resource: CardResource
var card_ref: Card:
	get:
		return card_resource.card_ref

func setup(p_card_resource: CardResource) -> void:
	card_resource = p_card_resource

func execute() -> void:
	pass
