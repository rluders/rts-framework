extends Node
class_name StateMachine

signal state_changed

@export var initial_state : State

var current_state : State
var states : Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is State:
			var state_name = child.name.to_lower()
			states[state_name] = child
			child.state_transitioned.connect(_on_state_transitioned)
	
	if initial_state:
		transition_to(initial_state.name.to_lower())

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func transition_to(state_name: String, params: Dictionary = {}) -> void:
	state_name = state_name.to_lower()
	var new_state = states.get(state_name)

	if not new_state:
		push_error("State '%s' not found" % state_name)
		return
	
	if current_state:
		current_state.exit()

	# Transition to the new state
	current_state = new_state
	current_state.enter(params)

	state_changed.emit(state_name)
	print_debug("State changed to:", state_name)

func _on_state_transitioned(state: State, new_state_name: String) -> void:
	if state != current_state:
		return
	
	transition_to(new_state_name)

func get_state(state_name: String) -> State:
	return states.get(state_name.to_lower())

func get_root_node():
	return get_parent()
