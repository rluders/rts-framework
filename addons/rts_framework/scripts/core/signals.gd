extends Node

# This needs to be registered as global singleton `Signals`

signal units_selected(units: Array)
signal command_issued(command: String, units: Array, target: Variant, context: Dictionary)

func emit_units_selected(units: Array) -> void:
	units_selected.emit(units)

func emit_command_issued(command: String, units: Array, target: Variant, context: Dictionary) -> void:
	command_issued.emit(command, units, target, context)
