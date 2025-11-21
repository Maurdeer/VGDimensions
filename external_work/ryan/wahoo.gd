extends Node2D

@onready var card: Card = $Card
@export var time_cooldown: float = 1000
var timer: Timer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	card.flip_reveal()
	do_something()
	
func do_something() -> void:
	while true:
		if card.get_parent():
			remove_child(card)
		else:
			add_child(card)
		await get_tree().create_timer(1).timeout
