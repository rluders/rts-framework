extends Node
class_name State

signal state_transitioned

func enter(data: StateData) -> void:
	pass

func exit(data: StateData) -> void:
	data.previous_states.push_front(get_state_name())

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func get_state_machine() -> StateMachine:
	var parent = get_parent()
	if not parent is StateMachine:
		push_error("Parent of State must be a StateMachine")
		return null
	
	return parent as StateMachine

func get_root_node():
	return get_state_machine().get_root_node()

func get_state_name() -> String:
	return name.to_lower()
