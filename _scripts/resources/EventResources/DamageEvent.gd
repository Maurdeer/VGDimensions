extends EventResource
class_name DamageEvent

@export var damage_amount: int

func execute() -> void:
	var card_to_dmg_pos: Vector2i = Mediator.Instance.request_player_card_selection()
	# "Deal damage to selected card here"
