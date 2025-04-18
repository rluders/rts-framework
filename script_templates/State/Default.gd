# meta-name: Default State
# meta-description: Base template for State
# meta-default: true

extends _BASE_
class_name _CLASS_

func enter(data: StateData = null) -> void:
	pass

func exit(data: StateData = null) -> void:
	if data != null:
		data.previous_states.push_front(get_state_name())

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass
