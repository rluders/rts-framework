@tool
extends Node
class_name RTSController

## This controller acts as a orquestrator for the core components of the framework,
## it handles their events and some other actions to allow they to easily communicate.

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

func _process(delta: float) -> void:
	if selection_manager.has_selected_units():
		# What is under the mouse? To change the mouse cursor
		pass

func _input(event: InputEvent) -> void:
	if selection_manager.has_selected_units():
		if Input.is_action_just_pressed("command"):
			var target = Raycaster.perform_raycast(255) # FIXME pass the correct mask
			if not target and not target.collider:
				return
			
			var target_group = get_target_group(target.collider)

			# FIXME This would probably go away when the detector start to work
			match target_group:
				"surface":
					handle_surface_target(target)
				"entities":
					handle_entities_target(target)
				_:
					print_debug("Unknown target group")
					return

func handle_surface_target(target: Variant) -> void:
	command_manager.issue_command(
		selection_manager.get_selected_units(),
		target.position,
		{"command_type": "move"}
	)

func handle_entities_target(target: Variant) -> void:
	var entity = target.collider.get_parent()
	var command_type
	
	if not entity:
		return
		
	if "team" in entity and entity.team != team:
		command_type = "attack"
	
	if command_type:
		command_manager.issue_command(
			selection_manager.get_selected_units(),
			entity,
			{"command_type": command_type}
		)

# FIXME This function would be probably used by the detector
func get_target_group(target: Variant):
	var groups = target.get_parent().get_groups()
	print(groups)
	if "surface" in groups:
		return "surface"
	if "entities" in groups:
		return "entities"
	return null
