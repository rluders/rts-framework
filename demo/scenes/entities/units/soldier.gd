extends UnitEntity
class_name Soldier

func _ready() -> void:
	super()
	#Signals.command_issued.connect(_on_command_issued)

#func _on_command_issued(command: String, units: Array, target: Variant, context: Dictionary) -> void:
	#if self not in units:
		#return
		
func _on_command_issued(command: String, target: Variant, context: Dictionary) -> void:
	match command:
		"move":
			state_machine.transition_to("move", {"target_position": target})
		"idle":
			state_machine.transition_to("idle")
		_:
			push_warning("Unknown command: %s" % command)
