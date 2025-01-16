# BuildingEntity

The `BuildingEntity` represents in-game structures such as barracks, factories, and resource depots. These buildings may produce units or provide other game functions. It builds on the `BaseEntity` functionality and integrates production-related components, like `QueueComponent`.

## **Class**

- **Base node/class**: `BaseEntity`
- **Class name**: `BuildingEntity`

## **Methods**

- `start_production(scene: PackedScene) -> void`: Adds a unit or other entity to the production queue, starting production if the queue is not full.
- `get_queue() -> QueueComponent`: Returns the `QueueComponent` associated with the building for managing production.

## **Properties**

- `@export var building_type: String = "default"`: Defines the type of the building (e.g., "Barracks", "Factory").
- `@export var production_time: float = 5.0`: The default time required to produce an item.

## **Events**

- None. The building interacts with the game through its components and does not emit events directly.

## **Dependencies**

- **QueueComponent**: The building must have a `QueueComponent` for managing production queues.

## Code

```gdscript
extends BaseEntity
class_name BuildingEntity

@export var building_type: String = "default"
@export var production_time: float = 5.0

func start_production(scene: PackedScene) -> void:
    var queue = get_queue()
    if queue:
        queue.add_to_queue(scene)
        queue.start_production()

func get_queue() -> QueueComponent:
    return get_component("QueueComponent") as QueueComponent
```