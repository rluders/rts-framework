@tool
extends Node
class_name RTSController

## This controller acts as an orchestrator for the core components of the framework.
## It handles events and some actions to allow components to communicate easily.

@export var team: int = 0

@export var selection_manager: SelectionManager:
	set(value):
		selection_manager = value
		update_configuration_warnings()

@export var command_manager: CommandManager:
	set(value):
		command_manager = value
		update_configuration_warnings()

var current_target

func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	if not selection_manager:
		warnings.append("The node 'SelectionManager' is missing. Add it to the scene and link it to the RTSController.")
	if not command_manager:
		warnings.append("The node 'CommandManager' is missing. Add it to the scene and link it to the RTSController.")
	return warnings

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	# Detect object under mouse for hover
	var target = Raycaster.perform_raycast(255)  # Replace with the correct mask
	if target or target.collider:
		if not current_target or target.collider != current_target.collider:
			current_target = target
			handle_hover_target()
	else:
		current_target = null

func _input(event: InputEvent) -> void:
	if not selection_manager.has_selected_units():
		return

	if Input.is_action_just_pressed("command"):
		if not current_target or not current_target.collider:
			return
		
		var target_group = get_target_group(current_target.collider)

		match target_group:
			"surface":
				handle_surface_target(current_target)
			"entities":
				handle_entities_target(current_target)
			_:
				print_debug("Unknown target group")

func handle_hover_target() -> void:
	var target_group = get_target_group(current_target.collider)
	match target_group:
		"surface":
			print("Hovering over surface")
		"entities":
			print("Hovering over entity")
		_:
			print("Hovering over unknown object")

func handle_surface_target(target: Dictionary) -> void:
	command_manager.issue_command(
		selection_manager.get_selected_units(),
		target.position,
		{"command_type": "move"}
	)

func handle_entities_target(target: Dictionary) -> void:
	var entity = target.collider.get_parent()
	var command_type
	
	if not entity:
		print_debug("Invalid entity target")
		return
		
	if "team" in entity and entity.team != team:
		command_type = "attack"
	else:
		command_type = "follow"

	if command_type:
		command_manager.issue_command(
			selection_manager.get_selected_units(),
			entity,
			{"command_type": command_type}
		)

func get_target_group(target: Node) -> String:
	if not target.get_parent():
		return ""
	
	var groups = target.get_parent().get_groups()
	if "surface" in groups:
		return "surface"
	if "entities" in groups:
		return "entities"
	return ""
