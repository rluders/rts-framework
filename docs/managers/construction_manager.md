# ConstructionManager

The `ConstructionManager` is a centralized system for handling the construction of buildings and other structures. It supports both worker-driven construction (e.g., workers building structures) and automatic queue-driven construction (e.g., Command & Conquer style).

## **Class**

- **Base node/class**: `Node`
- **Class name**: `ConstructionManager`

## **Methods**

- `start_construction(building_scene: PackedScene, target_position: Vector3, worker: UnitEntity = null) -> void`: Initiates construction of a building at the specified position. If a `worker` is provided, the worker will build the structure; otherwise, construction is immediate.
- `queue_construction(building: BuildingEntity, item: PackedScene) -> void`: Adds a construction item to a building’s `QueueComponent` for automatic production.

## **Properties**

- None. This system processes construction dynamically based on the parameters provided.

## **Events**

- `construction_started(building_type: String, builder: BaseEntity)`: Emitted when construction begins, providing details about the building type and builder.
- `construction_completed(building_instance: BaseEntity)`: Emitted when a building is successfully constructed.

## **Dependencies**

- **QueueComponent**: For queue-based construction (e.g., barracks building soldiers).
- **Worker Units**: Optional, for worker-driven construction logic.

## **Code**

```gdscript
extends Node
class_name ConstructionManager

signal construction_started(building_type: String, builder: BaseEntity)
signal construction_completed(building_instance: BaseEntity)

func start_construction(building_scene: PackedScene, target_position: Vector3, worker: UnitEntity = null) -> void:
    if worker:
        var build_state = worker.state_machine.states.get("build")
        if build_state:
            build_state.set_construction(building_scene, target_position)
            worker.state_machine.transition_to("build")
        emit_signal("construction_started", building_scene.resource_path, worker)
    else:
        # Immediate construction
        var building_instance = building_scene.instance()
        building_instance.global_transform.origin = target_position
        get_tree().current_scene.add_child(building_instance)
        emit_signal("construction_started", building_scene.resource_path, null)
        emit_signal("construction_completed", building_instance)

func queue_construction(building: BuildingEntity, item: PackedScene) -> void:
    var queue = building.get_component("QueueComponent")
    if queue:
        queue.add_to_queue(item)
        queue.start_production()
        emit_signal("construction_started", item.resource_path, building)
```