extends EventResource
class_name BuildingResetEvent

func on_execute() -> bool:
	m_card_invoker.can_activate = true
	print(m_card_invoker.can_activate)
	print("Activated HAHAH")
	return false

func required_events() -> Array[EventResource]:
	return []
