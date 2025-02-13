extends Node
class_name CommandManager

@export var team: int = 0:
	set(value):
		if value < 0:
			push_error("Team ID cannot be negative")
			return
		team = value

var current_target: Dictionary

func _process(delta: float) -> void:
	# Detect object under mouse for hover
	var new_target = Raycaster.perform_raycast(255)  # Adjust mask as necessary
	if new_target and new_target.collider:
		current_target = new_target
	else:
		current_target = {}

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("command"):
		if not current_target or not current_target.collider:
			return

		var selected_units = get_selected_units()
		if selected_units.is_empty():
			return
			

		if not current_target.collider:
			return

		var target_group = get_target_group(current_target.collider)
		print_debug(current_target.collider, target_group)

		match target_group:
			"surface":
				issue_surface_command(selected_units, current_target)
			"entities":
				issue_entity_command(selected_units, current_target)
			_:
				push_error("Unknown target group: %s" % target_group)

# --- Command Handlers ---
func issue_surface_command(units: Array, target: Dictionary) -> void:
	emit_command_issued("move", target.position, {"target_group": "surface"})

func issue_entity_command(units: Array, target: Dictionary) -> void:
	var entity = target.collider.get_parent()
	if not entity:
		push_error("Invalid entity target")
		return

	var command_type = "follow"
	if "team" in entity and entity.team != team:
		command_type = "attack"
	
	emit_command_issued(command_type, entity, {"target_group": "entities"})

# --- Helper Methods ---
func emit_command_issued(command: String, target: Variant, context: Dictionary) -> void:
	var team_group = "team_%d_selected" % team
	get_tree().call_group(team_group, "_on_command_issued", command, target, context)

func get_target_group(target: Node) -> String:
	if not target:
		return ""

	var groups = target.get_groups()
	if "surface" in groups:
		return "surface"
	if "entities" in groups:
		return "entities"
	return ""

func get_selected_units() -> Array:
	# Retrieve selected units from the relevant group
	return get_tree().get_nodes_in_group("team_%d_selected" % team)
