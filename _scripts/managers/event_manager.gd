extends Node

var _callable_queue: Array[Callable]

var stored_card: Dictionary[int, Card]
func process_event_queue() -> void:
	var failure: bool = _callable_queue.pop_front().call()
	if failure:
		push_error("An Event Failed!!!!")
		return
	
	
func queue_event(event: EventResource, card_invoker: Card) -> void:
	if not event:
		push_warning("Pushed Null Event, didn't add to queue")
		return 
		
	_callable_queue.push_back(func() -> bool: return event.execute(card_invoker))
	
func queue_event_group(events: Array[EventResource], card_invoker: Card) -> void:
	# TODO: Let the SelectionEvent Know its undoable or not
	var group_event_callable: Callable = func() -> bool:
		var pass_selection: bool = false
		for event in events:
			if not event:
				push_warning("Null Event Found and not processed")
				continue
			if event is SelectionEventResource:
				if not event.select(card_invoker):
					return pass_selection
			else:
				pass_selection = true
				if not event.execute(card_invoker):
					return false
				
		return false
			
	_callable_queue.push_back(group_event_callable)
