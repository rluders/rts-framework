extends Node

# This needs to be registered as global singleton `Signals`

signal units_selected(units: Array)
signal command_issued(command: String, units: Array, target: Variant, context: Dictionary)

func emit_units_selected(units: Array) -> void:
	emit_signal("units_selected", units)

func emit_command_issued(command: String, units: Array, target: Variant, context: Dictionary) -> void:
	emit_signal("command_issued", command, units, target, context)
