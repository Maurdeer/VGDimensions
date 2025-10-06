extends EventResource
class_name HealEvent

@export var self_heal: bool = false
@export var health_amount: int
@export var cap_at_starting_hp: bool

func execute(card_ref: Card) -> void:
	if self_heal:
		card_ref.hp += health_amount
		if cap_at_starting_hp:
			if card_ref.hp > card_ref.resource.starting_hp:
				card_ref.hp = card_ref.resource.starting_hp
