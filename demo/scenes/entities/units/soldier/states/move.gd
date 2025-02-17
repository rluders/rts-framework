extends State

@onready var soldier : UnitEntity = get_owner()

func enter() -> void:
	print_debug("Enter: ", self.name)

func exit() -> void:
	print_debug("Exit: ", self.name)

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	if soldier.navigation_agent.is_navigation_finished():
		state_transitioned.emit(self, "idle")
		return
	
	soldier.move_toward(soldier.navigation_agent.get_next_path_position(), soldier.speed*_delta)

func set_target(target_position: Vector3):
	soldier.navigation_agent.target_position = target_position
