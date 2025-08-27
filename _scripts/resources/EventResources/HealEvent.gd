extends EventResource
class_name HealEvent

@export var health_amount: int
@export var heal_to_starting_hp: bool

func execute() -> void:
	# Warning: Infering to card_ref directly may only update to local peer
	# For now this is fine, but good to warn for later conversion.
	card_ref.hp += health_amount
	if heal_to_starting_hp \
	and card_ref.hp > card_resource.starting_hp:
		card_ref.hp = card_resource.starting_hp
