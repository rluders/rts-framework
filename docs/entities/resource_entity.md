# ResourceEntity

The `ResourceEntity` represents collectable resources on the game map, such as gold, wood, or minerals. It inherits from `BaseEntity` and integrates with the `CollectableComponent` to manage resource collection and depletion.

## **Class**

- **Base node/class**: `BaseEntity`
- **Class name**: `ResourceEntity`

## **Methods**

- `get_remaining_resources() -> int`: Returns the amount of resources still available in this entity.
- `collect_resources(amount: int) -> int`: Reduces the resource amount by the specified amount and returns the actual amount collected.

## **Properties**

- `@export var resource_type: String = "default"`: Specifies the type of resource (e.g., "gold", "wood").
- `@export var resource_amount: int = 100`: The total amount of resources available in this entity.
- `@export var is_collectable: bool = true`: Indicates whether this resource can currently be collected.

## **Events**

- None. The resource entity interacts through its components, such as `CollectableComponent`.

## **Dependencies**

- **CollectableComponent**: Manages the logic for collecting resources.

## Code

```gdscript
extends BaseEntity
class_name ResourceEntity

@export var resource_type: String = "default"
@export var resource_amount: int = 100
@export var is_collectable: bool = true

func get_remaining_resources() -> int:
    return resource_amount

func collect_resources(amount: int) -> int:
    if !is_collectable:
        return 0
    var collected = min(amount, resource_amount)
    resource_amount -= collected
    return collected
```