extends Node

var _callable_queue: Array[Array]

var stored_card: Dictionary[int, Card]
var selection: Card

# returns false is Completed, true if canceled by player input
func process_event_queue() -> bool:
	if _callable_queue.is_empty():
		push_warning("Called Process Event Queue, but queue was empty")
		return true
	
	var card_refs: Dictionary[int, Card] = {}
	var pass_selection: bool = false
	var process_result: ProcessResult = ProcessResult.SUCCESS
	while not _callable_queue.is_empty():
		var event_pair: Array = _callable_queue.pop_front()
		var event: EventResource = event_pair[0]
		var card_invoker: Card = event_pair[1]
	
		if not event:
			push_warning("Null Event was found in event queue! System Fault!")
			continue
		if event is SelectionEventResource:
			if GameManager.Instance.is_my_turn():
				selection = await event.select(card_invoker, not pass_selection)
				if not selection:
					if pass_selection:
						process_result = ProcessResult.FAILED
					else:
						process_result = ProcessResult.CANCELED
					break
				broadcast_selection.rpc(selection.card_id)
			# Await for the selection event to complete
			GNM.barrier() 
			# Network that selection!
			card_refs[event.store_at] = selection
		else:
			pass_selection = false
			if event.execute(card_invoker, card_refs):
				process_result = ProcessResult.FAILED
			
	match (process_result):
		ProcessResult.CANCELED:
			return true
		ProcessResult.FAILED:
			push_error("Process had failed unexpectadly")
			return true
			
	return false

@rpc("call_remote", "any_peer", "reliable")
func broadcast_selection(cid: int):
	selection = CardManager.get_card_by_id(cid)
	
func queue_event(event: EventResource, card_invoker: Card) -> void:
	if not event:
		push_warning("Pushed Null Event, didn't add to queue")
		return 
		
	_callable_queue.push_back([event, card_invoker])
	
func queue_event_group(events: Array, card_invoker: Card) -> void:
	for event in events:
		if not event or not event is EventResource:
			push_warning("Null Event found, will not be pushed to event_queue! Designer Fault!")
			continue
		_callable_queue.push_back([event, card_invoker])
	
enum ProcessResult {
	SUCCESS,
	CANCELED,
	FAILED
}
