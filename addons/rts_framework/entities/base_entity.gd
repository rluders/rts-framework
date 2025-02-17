extends Node3D
class_name BaseEntity

@export var team: int = 0
@export var is_active: bool = true

func _ready() -> void:
	print_debug("Calling framework BaseEntity::_ready")
	add_to_group("entities")

func get_component(component_class: String) -> Node:
	if has_node("Components"):
		var components = $Components.get_children()
		for component in components:
			if component is BaseComponent:
				return component
	return null

func has_component(component_class: String) -> bool:
	return true if get_component(component_class) else false

func is_revealing() -> bool:
	return false;
