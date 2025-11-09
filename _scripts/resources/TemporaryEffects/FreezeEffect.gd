extends TemporaryEffect
class_name FreezeEffect

#@export var amount: int = 1

func on_execute() -> bool:
	# Directly damage the card
	on_effect_progress()
	return false
	
func required_events() -> Array[EventResource]:
	return []
	
func on_effect_apply() -> void:
	super.on_effect_apply()
	m_card_invoker.interactable = false
	m_card_invoker.on_freeze();
	
func on_effect_finish() -> void:
	m_card_invoker.interactable = true
	super.on_effect_finish()
