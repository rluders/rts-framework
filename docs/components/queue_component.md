# QueueComponent

The `QueueComponent` manages the production queue for buildings or units. It tracks items in the queue, handles production timing, and emits events when production is completed. This component is typically used in conjunction with `BuildingEntity`.

## **Class**

- **Base node/class**: `Node`
- **Class name**: `QueueComponent`

## **Methods**

- `add_to_queue(item: PackedScene) -> void`: Adds a new item (e.g., a unit or building) to the production queue if there is available space.
- `start_production() -> void`: Begins the production process for the first item in the queue.
- `_on_production_complete() -> void`: Internal method called when production is complete. Removes the item from the queue and emits the appropriate event.

## **Properties**

- `@export var max_queue_size: int = 5`: The maximum number of items that can be added to the queue.
- `@export var production_time: float = 5.0`: The time required to produce each item.
- `var production_queue: Array`: The current queue of items waiting to be produced.

## **Events**

- `queue_updated(queue: Array)`: Emitted whenever the queue is updated (e.g., item added or removed).
- `production_complete(produced_item: BaseEntity)`: Emitted when an item is produced.

## **Dependencies**

- None directly. This component can be used independently but is typically attached to a `BuildingEntity`.

## **Code**

```gdscript
extends Node
class_name QueueComponent

signal queue_updated(queue: Array)
signal production_complete(produced_item: BaseEntity)

@export var max_queue_size: int = 5
@export var production_time: float = 5.0

var production_queue: Array = []

func add_to_queue(item: PackedScene) -> void:
    if production_queue.size() < max_queue_size:
        production_queue.append(item)
        emit_signal("queue_updated", production_queue)

func start_production() -> void:
    if production_queue.size() > 0:
        var timer = Timer.new()
        add_child(timer)
        timer.wait_time = production_time
        timer.one_shot = true
        timer.connect("timeout", self, "_on_production_complete")
        timer.start()

func _on_production_complete() -> void:
    if production_queue.size() > 0:
        var scene = production_queue.pop_front()
        var instance = scene.instance()
        emit_signal("production_complete", instance)
        emit_signal("queue_updated", production_queue)
```