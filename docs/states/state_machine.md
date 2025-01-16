# StateMachine

The `StateMachine` is a generic system for managing the state of an entity. It transitions between states, executes their behaviors, and coordinates lifecycle events like entering, updating, and exiting a state. This is used extensively for units and buildings to handle actions like moving, attacking, and collecting resources.

## **Class**

- **Base node/class**: `Node`
- **Class name**: `StateMachine`

## **Methods**

- `transition_to(state_name: String) -> void`: Transitions the `StateMachine` to a new state, triggering the appropriate exit and enter events.
- `_on_state_transitioned(state: State, new_state_name: String) -> void`: Handles signals from the current state to initiate a transition to a new state.

## **Properties**

- `@export var initial_state: State`: The state to activate when the `StateMachine` initializes.
- `var current_state: State`: The currently active state.
- `var states: Dictionary`: A collection of available states, mapped by name.

## **Events**

- `state_changed(new_state_name: String)`: Emitted whenever the `StateMachine` transitions to a new state.

## **Dependencies**

- **States (children)**: The `StateMachine` expects its child nodes to be instances of the `State` class, representing the different states it can manage.

## Code

```gdscript
extends Node
class_name StateMachine

signal state_changed(new_state_name: String)

@export var initial_state: State

var current_state: State
var states: Dictionary = {}

func _ready() -> void:
    # Collect all child states and connect their signals
    for child in get_children():
        if child is State:
            states[child.name.to_lower()] = child
            child.state_transitioned.connect(_on_state_transitioned)
    
    # Initialize with the initial state if defined
    if initial_state:
        initial_state.enter()
        current_state = initial_state

func _process(delta: float) -> void:
    if current_state:
        current_state.update(delta)

func _physics_process(delta: float) -> void:
    if current_state:
        current_state.physics_update(delta)

func transition_to(state_name: String) -> void:
    var new_state = states.get(state_name.to_lower())
    if new_state and new_state != current_state:
        if current_state:
            current_state.exit()
        new_state.enter()
        current_state = new_state
        emit_signal("state_changed", state_name)

func _on_state_transitioned(state: State, new_state_name: String) -> void:
    if state == current_state:
        transition_to(new_state_name)
```