extends TemporaryEffect
class_name BurnEffect

@export var duration: int = 3
@export var amount: int = 2
var curr_duration: int

func on_execute() -> bool:
	# Directly damage the card
	if m_card_invoker.is_state() or m_card_invoker.deck_pos != 0: 
		on_duration_remove()
		return false
	m_card_invoker.damage(amount)
	on_duration_progress()
	return false
	
func required_events() -> Array[EventResource]:
	return []
	
func on_duration_create() -> void:
	curr_duration = duration
	
func on_duration_progress() -> void:
	curr_duration -= 1
	if curr_duration <= 0:
		on_duration_remove()
	
func on_duration_remove() -> void:
	m_card_invoker.remove_passive_event(self)
