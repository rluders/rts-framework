extends Node3D
class_name BaseEntity

const COMPONENT_NAME_ENDING : String = "Component"

@export var team: int = 0
@export var is_active: bool = true

@export var sight_range : int = 2

var components : Array[Node] = []

func _ready() -> void:
	print_debug("Calling framework BaseEntity::_ready")
	add_to_group("entities")
	if has_node("Components"):
		# Initialize components array with existing components
		for child in $Components.get_children():
			components.append(child)
		$Components.connect("child_entered_tree", _on_new_component_added)
		$Components.connect("child_exiting_tree", _on_new_component_removed)

func get_component(component_class: String) -> Node:
	for component in components:
		if component.name == component_class + COMPONENT_NAME_ENDING:
			return component
	return null

func has_component(component_class: String) -> bool:
	return true if get_component(component_class) else false

func is_revealing() -> bool:
	return true;

func _on_new_component_added(component : Node) -> void:
	components.append(component)

func _on_new_component_removed(component : Node) -> void:
	components.erase(component)
