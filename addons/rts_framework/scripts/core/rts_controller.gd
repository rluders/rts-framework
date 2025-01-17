@tool
extends Node
class_name RTSController

@export var team : int = 0

@export var selection_manager: SelectionManager:
	set(value):
		selection_manager = value
		update_configuration_warnings()

@export var command_manager: CommandManager:
	set(value):
		command_manager = value
		update_configuration_warnings()

func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	if not selection_manager:
		warnings.append("The node 'SelectionManager' is missing. Add it to the scene and link it to the RTSController.")
	if not command_manager:
		warnings.append("The node 'CommandManager' is missing. Add it to the scene and link it to the RTSController.")
	return warnings
