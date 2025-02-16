extends Node
class_name ConstructionManager

signal construction_started(scene: PackedScene)
signal construction_completed(produced_entity: BaseEntity)
signal construction_progress_updated(progress: float)

@export var queue: QueueComponent
@export var production_time: float = 5.0

var current_scene : PackedScene
var is_producing: bool = false
var remaining_time: float = 0.0

func _ready() -> void:
	pass

func request_construction(scene: PackedScene) -> void:
	if not queue:
		push_error("No QueueComponent assigned to ConstructionManager.")
		return

	if queue.is_full():
		push_warning("Construction queue is full.")
		return
	
	queue.add_to_queue(scene)
	
	if not queue.is_empty() and not is_producing:
		start_production()

func start_production() -> void:
	if queue.is_empty() or is_producing:
		return
	
	is_producing = true
	# TODO It would be nice have production_time per item
	remaining_time = production_time
	
	current_scene = queue.dequeue()
	construction_started.emit(current_scene)

func _process(delta: float) -> void:
	if is_producing:
		remaining_time -= delta
		# Emit construction progress
		construction_progress_updated.emit(1.0 - (remaining_time / production_time))
		
		if remaining_time <= 0:
			complete_construction()

func complete_construction() -> void:	
	if not current_scene:
		push_error("ConstructionManager: No entity set for construction!")
		is_producing = false
		return
		
	# Emit the event, but don't instantiate anything automatically
	construction_completed.emit(current_scene)

	# Reset and continue production if queue is not empty
	current_scene = null
	if not queue.is_empty():
		start_production()
	else:
		is_producing = false
