extends Object
class_name Queue
# TODO: Create this to give us an O(1) optimization for Audio Manager

#var backing_array: Array = [null] * 10
#var size: int = 0
#var head: int = 0
#var tail: int = 0
#
#func enqueue(data) -> void:
	#if size > backing_array.size():
		#_resize_queue()
	#backing_array[tail] = data
	#tail += 1
	#size += 1
	#
#func dequeue():
	#if is_empty():
		#push_error("nothing to dequeue because queue is empty!")
		#return null
	#
	#var temp = backing_array[queue_idx]
	#size -= 1
	#if size == 0:
		#queue_idx = 0
	#else:
		#queue_idx = (queue_idx + 1) % backing_array.size()
	#return 
	#
#func is_empty() -> bool:
	#return size == 0
	#
#func _resize_queue() -> void:
	#var arr = []
	#while not is_empty():
		#arr.append(dequeue())
	#backing_array.resize(backing_array.size() * 2)
	#while 
