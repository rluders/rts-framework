extends UnitEntity
class_name Soldier

@export var material : StandardMaterial3D

func _ready() -> void:
	super()
	$MeshInstance3D.material_override = material

func _on_command_issued(command: String, target: Variant, context: Dictionary) -> void:
	match command:
		"move":
			state_machine.transition_to("move", {"target_position": target})
		"idle":
			state_machine.transition_to("idle")
		_:
			push_warning("Unknown command: %s" % command)
