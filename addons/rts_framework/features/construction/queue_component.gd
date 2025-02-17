extends BaseComponent
class_name QueueComponent

signal queue_updated(queue: Array)

@export var max_queue_size: int = 5
var queue: Array = []

func add_to_queue(item: Variant) -> void:
	if queue.size() >= max_queue_size:
		push_warning("Queue is full.")
		return
	
	queue.append(item)
	queue_updated.emit(queue)

func dequeue() -> Variant:
	if queue.is_empty():
		return null

	var item = queue.pop_front()
	queue_updated.emit(queue)
	return item

func peek() -> Variant:
	return queue.front() if not queue.is_empty() else null

func clear_queue() -> void:
	queue.clear()
	queue_updated.emit(queue)

func is_full() -> bool:
	return queue.size() >= max_queue_size

func is_empty() -> bool:
	return queue.is_empty()
