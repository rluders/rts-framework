extends Node
class_name StateMachine

signal state_changed

@export var initial_state : State

var current_state : State
var states : Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.state_transitioned.connect(_on_state_transitioned)
	
	if initial_state:
		initial_state.enter()
		current_state = initial_state

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func _on_state_transitioned(state: State, new_state_name: String) -> void:
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current_state:
		current_state.exit()
	
	new_state.enter()
	current_state = new_state
	
	state_changed.emit(new_state_name.to_lower())

func get_state(state_name: String) -> State:
	var state : State = states.get(state_name.to_lower())
	if not state:
		push_error("State '%s' not found" % state_name)
		return null
	return state

func _handle_state_transition(new_state: State) -> void:
	if current_state:
		current_state.exit()
	current_state = new_state

func transition_to(state_name: String, params: Dictionary = {}) -> void:
	var state = states.get(state_name)
	if not state:
		push_error("State '%s' not found" % state_name)
		return
	
	if current_state:
		current_state.exit()
	
	_handle_state_transition(state)
	
	state.enter(params)
	state_changed.emit(state_name)

func get_root_node():
	return get_parent()
