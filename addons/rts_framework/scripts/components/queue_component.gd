extends Node
class_name QueueComponent

signal on_item_added(item: String)
signal on_item_completed(item: String)
signal on_item_removed(item: String)

@export var build_time: float = 5.0  # Default build time for items

var queue: Array = []
var current_item: String = ""
var time_remaining: float = 0.0

func _process(delta: float) -> void:
    if current_item == "":
        start_next_item()
    elif time_remaining > 0:
        process_queue(delta)

func add_to_queue(item: String) -> void:
    queue.append(item)
    emit_signal("on_item_added", item)
    if current_item == "":
        start_next_item()

func remove_from_queue(item: String) -> void:
    if item in queue:
        queue.erase(item)
        emit_signal("on_item_removed", item)
    if item == current_item:
        complete_current_item()

func process_queue(delta: float) -> void:
    time_remaining -= delta
    if time_remaining <= 0:
        complete_current_item()

func start_next_item() -> void:
    if queue.size() > 0:
        current_item = queue.pop_front()
        time_remaining = build_time
    else:
        current_item = ""
        time_remaining = 0.0

func complete_current_item() -> void:
    if current_item != "":
        emit_signal("on_item_completed", current_item)
        current_item = ""
        start_next_item()
