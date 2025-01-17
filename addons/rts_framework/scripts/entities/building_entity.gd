extends BaseEntity
class_name BuildingEntity

@export var building_type: String = "default"
@export var production_time: float = 5.0

func _ready() -> void:
	add_to_group("buildings")

func start_production(scene: PackedScene) -> void:
	var queue = get_queue()
	if queue:
		queue.add_to_queue(scene)
		queue.start_production()

func get_queue() -> QueueComponent:
	return get_component("QueueComponent") as QueueComponent
