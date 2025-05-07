extends UnitEntity
class_name Soldier

@export var material : StandardMaterial3D

# To get the node itself as CharacterBody3D and not as Soldier.
# Soldier originally extends from Node3D. Hence missing some properties and function that CharacterBody3D has
@onready var character_body : CharacterBody3D = $"." as CharacterBody3D

func _ready() -> void:
	super()
	$MeshInstance3D.material_override = material

func _on_command_issued(command: String, target: Variant, context: Dictionary) -> void:
	var data : MoveData = MoveData.new()
	data.target_position = target
	match command:
		"move":
			state_machine.transition_to("move", data)
		"idle":
			state_machine.transition_to("idle")
		_:
			push_warning("Unknown command: %s" % command)

func _update_unit_position_on_velocity_computed(safe_velocity: Vector3) -> void:
	character_body.velocity = safe_velocity
	character_body.move_and_slide()
