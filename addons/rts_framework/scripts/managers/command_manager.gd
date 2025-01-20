extends Node
class_name CommandManager

signal command_issued(command: String, units: Array, target: Variant, context: Dictionary)

func issue_command(units: Array, target: Variant, context: Dictionary) -> void:
	if units.is_empty():
		push_error("Cannot issue command: No units provided")
		return
	if target == null:
		push_error("Cannot issue command: Invalid target")
		return

	# Extract the command type from the context (default to "default")
	var command = context.get("command_type", "default")
	
	# Emit the event for all listeners, passing the command details
	emit_signal("command_issued", command, units, target, context)
	
	# Handle common commands directly
	match command:
		"move":
			for unit in units:
				if unit.has_method("move_to")
					print(unit.name, " moves to ", target)
		"attack":
			for unit in units:
				if unit.has_method("attack"):
					print(unit.name + " attacks ", target)
		"build":
			for unit in units:
				if unit.has_method("build"):
					print(unit.name + " builinds at ", target)
		"collect":
			for unit in units:
				if unit.has_method("collect"):
					print(unit.name + " collects ", target)
		_:
			push_error("Unknown command type: %s" % command)

