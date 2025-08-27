extends EventResource
class_name HealEvent

@export var health_amount: int
@export var heal_to_starting_hp: bool

func execute() -> void:
	card_resource.card_ref.hp += health_amount
	if heal_to_starting_hp \
	and card_resource.card_ref.hp > card_resource.starting_hp:
		card_resource.card_ref.hp = card_resource.starting_hp
