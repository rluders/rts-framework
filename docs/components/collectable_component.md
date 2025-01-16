# CollectableComponent

The `CollectableComponent` adds resource collection functionality to entities, such as resource nodes. It manages the logic for reducing the available resource amount and returning the collected quantity to the requesting unit.

## **Class**

- **Base node/class**: `Node`
- **Class name**: `CollectableComponent`

## **Methods**

- `collect(amount: int) -> int`: Reduces the resource amount by the specified amount and returns the actual quantity collected. If no resources are available, it returns 0.
- `get_remaining_resources() -> int`: Returns the current amount of resources remaining.

## **Properties**

- `@export var resource_amount: int = 100`: The total amount of resources initially available.
- `@export var resource_type: String = "default"`: The type of resource (e.g., "gold", "wood").
- `@export var is_collectable: bool = true`: Determines whether the resource can currently be collected.

## **Events**

- `resources_depleted()`: Emitted when the resource amount reaches 0.

## **Dependencies**

- None directly. This component can be attached to any entity, but it is typically used with `ResourceEntity`.

## **Code**

```gdscript
extends Node
class_name CollectableComponent

signal resources_depleted()

@export var resource_amount: int = 100
@export var resource_type: String = "default"
@export var is_collectable: bool = true

func collect(amount: int) -> int:
    if !is_collectable or resource_amount <= 0:
        return 0
    var collected = min(amount, resource_amount)
    resource_amount -= collected
    if resource_amount <= 0:
        emit_signal("resources_depleted")
    return collected

func get_remaining_resources() -> int:
    return resource_amount
```