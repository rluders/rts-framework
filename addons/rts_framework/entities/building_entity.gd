extends BaseEntity
class_name BuildingEntity

@export var building_type: String = "default"
@export var production_time: float = 5.0

func _ready() -> void:
	add_to_group("buildings")

# Adds a production item to the queue and starts production
func start_production(scene: PackedScene) -> void:
	var queue = get_component("Queue") as QueueComponent
	if queue:
		queue.add_to_queue(scene)
		if not queue.is_producing:
			queue.start_production()
