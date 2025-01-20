extends Node
class_name CommandManager

@export var team: int = 0

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
			return;

		var target_group = get_target_group(current_target.collider)

		match target_group:
			"surface":
				issue_surface_command(selected_units, current_target)
			"entities":
				issue_entity_command(selected_units, current_target)
			_:
				print_debug("Unknown target group")

# --- Command Handlers ---
func issue_surface_command(units: Array, target: Dictionary) -> void:
	Signals.emit_command_issued(
		"move",
		units,
		target.position,
		{"target_group": "surface"}
	)

func issue_entity_command(units: Array, target: Dictionary) -> void:
	var entity = target.collider.get_parent()
	if not entity:
		print_debug("Invalid entity target")
		return

	var command_type = "follow"
	if "team" in entity and entity.team != team:
		command_type = "attack"

	Signals.emit_command_issued(
		command_type,
		units,
		entity,
		{"target_group": "entities"}
	)

# --- Helper Methods ---
func get_target_group(target: Node) -> String:
	if not target.get_parent():
		return ""

	var groups = target.get_parent().get_groups()
	if "surface" in groups:
		return "surface"
	if "entities" in groups:
		return "entities"
	return ""

func get_selected_units() -> Array:
	# Retrieve selected units from the relevant group
	var units = []
	for unit in get_tree().get_nodes_in_group("team_%d_selected" % team):
		units.append(unit)
	return units
