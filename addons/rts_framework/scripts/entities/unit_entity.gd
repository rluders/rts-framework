extends BaseEntity
class_name UnitEntity

@onready var state_machine: StateMachine = $StateMachine
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

func _ready() -> void:
	add_to_group("units")

func move_to(target_position: Vector3) -> void:
	var move_state = state_machine.states.get("move")
	if move_state:
		move_state.set_target(target_position)
		state_machine.transition_to("move")

func attack(target: BaseEntity) -> void:
	var attack_state = state_machine.states.get("attack")
	if attack_state:
		attack_state.set_target(target)
		state_machine.transition_to("attack")

func build(target_position: Vector3, scene: PackedScene) -> void:
	var build_state = state_machine.states.get("build")
	if build_state:
		build_state.set_construction(scene, target_position)
		state_machine.transition_to("build")

func collect(resource: BaseEntity) -> void:
	var collect_state = state_machine.states.get("collect")
	if collect_state:
		collect_state.set_target(resource)
		state_machine.transition_to("collect")
