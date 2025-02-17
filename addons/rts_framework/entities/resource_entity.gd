extends BaseEntity
class_name ResourceEntity

@export var resource_type: String = "default"
@export var resource_amount: int = 100
@export var is_collectable: bool = true

func _ready() -> void:
	add_to_group("resources")

func get_remaining_resources() -> int:
	return resource_amount

func collect_resources(amount: int) -> int:
	if !is_collectable:
		return 0
	var collected = min(amount, resource_amount)
	resource_amount -= collected
	return collected
