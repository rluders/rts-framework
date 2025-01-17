extends Node3D
class_name BaseEntity

@export var team: int = 0
@export var is_active: bool = true

func _ready() -> void:
	add_to_group("entities")

func get_component(component_class: String) -> Node:
	if has_node("Components"):
		var components = $Components.get_children()
		for component in components:
			# FIXME it would nice to check it with get_class() but it always get Node
			if component.name == component_class + "Component":
				return component
	return null

func has_component(component_class: String) -> bool:
	return true if get_component(component_class) else false
