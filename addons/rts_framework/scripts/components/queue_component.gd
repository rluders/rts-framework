extends Node
class_name QueueComponent

signal queue_updated(queue: Array)
signal production_complete(produced_item: BaseEntity)

@export var max_queue_size: int = 5
@export var production_time: float = 5.0

var production_queue: Array = []
var current_production_time: float = 0.0
var is_producing: bool = false

func _ready() -> void:
	# Ensure the component is initialized correctly
	if Engine.is_editor_hint():
		return

func _process(delta: float) -> void:
	if not is_producing or production_queue.is_empty():
		return
	
	current_production_time -= delta
	
	if current_production_time <= 0.0:
		_on_production_complete()

func add_to_queue(item: PackedScene) -> void:
	if production_queue.size() >= max_queue_size:
		push_warning("Queue is full. Cannot add more items.")
		return
	
	production_queue.append(item)
	queue_updated.emit(production_queue)  # Proper signal emission
	
	# Automatically start production if not already producing
	if not is_producing:
		start_production()

func start_production() -> void:
	if production_queue.is_empty() or is_producing:
		return
	
	is_producing = true
	current_production_time = production_time

func remove_from_queue(item: PackedScene) -> void:
	if item in production_queue:
		production_queue.erase(item)
		queue_updated.emit(production_queue)  # Proper signal emission

func clear_queue() -> void:
	production_queue.clear()
	is_producing = false
	current_production_time = 0.0
	queue_updated.emit(production_queue)  # Proper signal emission

func _on_production_complete() -> void:
	# Remove the first item from the queue
	if production_queue.is_empty():
		is_producing = false
		return
	
	var item_to_produce = production_queue.pop_front()
	queue_updated.emit(production_queue)  # Proper signal emission
	
	# Instantiate the item and emit the production complete signal
	var produced_instance = item_to_produce.instance()
	production_complete.emit(produced_instance)  # Proper signal emission

	# Add the produced instance to the scene
	if produced_instance:
		get_tree().current_scene.add_child(produced_instance)

	# Continue with the next item in the queue
	if not production_queue.is_empty():
		start_production()
	else:
		is_producing = false
