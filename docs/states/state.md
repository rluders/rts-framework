# State

The `State` class represents an individual state within the `StateMachine`. It encapsulates specific behavior, such as movement, attacking, or idle actions, and provides hooks for lifecycle events like entering, updating, and exiting the state.

## **Class**

- **Base node/class**: `Node`
- **Class name**: `State`

## **Methods**

- `enter() -> void`: Called when the `StateMachine` transitions into this state. Used to initialize state-specific logic.
- `exit() -> void`: Called when the `StateMachine` transitions out of this state. Used to clean up state-specific logic.
- `update(delta: float) -> void`: Called every frame while this state is active. Used for per-frame updates.
- `physics_update(delta: float) -> void`: Called during the physics process while this state is active. Used for physics-related logic.

## **Properties**

- None. States rely on the owning entity or state machine for context.

## **Events**

- `state_transitioned(new_state_name: String)`: Emitted to request a transition to another state.

## **Dependencies**

- **StateMachine**: The `State` is managed by the `StateMachine` and must be a child of it.

## **Code**

```gdscript
extends Node
class_name State

signal state_transitioned(new_state_name: String)

func enter() -> void:
    # Called when this state becomes active
    pass

func exit() -> void:
    # Called when this state is no longer active
    pass

func update(delta: float) -> void:
    # Called every frame while this state is active
    pass

func physics_update(delta: float) -> void:
    # Called during the physics process while this state is active
    pass
```