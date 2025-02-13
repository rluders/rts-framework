extends Node
class_name State

signal state_transitioned

func enter() -> void:
	pass

func exit() -> void:
	pass

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
