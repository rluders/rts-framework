extends Node
class_name CommandManager

signal command_issued(command: String, units: Array, target: Variant, context: Dictionary)

func issue_command(units: Array, target: Variant, context: Dictionary) -> void:
	# Extract the command type from the context (default to "default")
	var command = context.get("command_type", "default")
	
	# Emit the event for all listeners, passing the command details
	emit_signal("command_issued", command, units, target, context)
	
	# Handle common commands directly
	match command:
		"move":
			for unit in units:
				print(unit.name, " moves to ", target)
		"attack":
			for unit in units:
				print(unit.name + " attacks ", target)
		"build":
			for unit in units:
				print(unit.name + " builinds at ", target)
		"collect":
			for unit in units:
				print(unit.name + " collects ", target)
		_:
			print("Unknown command type:", command)
