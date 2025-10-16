extends TemporaryEffect
class_name BurnEffect

@export var duration: int = 3
@export var amount: int = 2
var curr_duration: int

func on_execute() -> bool:
	on_duration_progress()
	#m_card_invoker.damage(amount)
	return false
	
func required_events() -> Array[EventResource]:
	return []
	
func on_duration_create() -> void:
	curr_duration = duration
	
func on_duration_progress() -> void:
	curr_duration -= 1
	
func on_duration_remove() -> void:
	pass
