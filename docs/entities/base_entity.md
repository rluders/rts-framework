# BaseEntity

The `BaseEntity` is the foundational class for all game entities, including units, buildings, and resources. It provides a consistent interface and shared functionality, such as team ownership and component management.

## **Class**

- **Base node/class**: `Node3D`
- **Class name**: `BaseEntity`

## **Methods**

- `get_component(component_class: String) -> Node`: Returns a specific component attached to the entity by its class name. If the component is not found, it returns `null`.

## **Properties**

- `@export var team: int = 0`: The team to which the entity belongs.
- `@export var is_active: bool = true`: Determines if the entity is active in the game.

## **Events**

- None. This class serves as a foundational structure without emitting events directly.

## **Dependencies**

- **Components**: The entity is expected to have a `Components` node as its child, which contains reusable components like `SelectableComponent`, `DamageableComponent`, etc.

## Code

```gdscript
extends Node3D
class_name BaseEntity

@export var team: int = 0
@export var is_active: bool = true

func get_component(component_class: String) -> Node:
    if has_node("Components"):
        var components = $Components.get_children()
        for component in components:
            if component.get_class() == component_class:
                return component
    return null
```