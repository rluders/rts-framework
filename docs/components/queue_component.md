# QueueComponent

The `QueueComponent` manages the production queue for buildings or units. It tracks items in the queue, handles production timing, and emits events when production is completed. This component is typically used in conjunction with `BuildingEntity` or similar entities that manage production logic.

## **Class**

- **Base node/class**: `Node`
- **Class name**: `QueueComponent`

## **Methods**

- **`add_to_queue(item: PackedScene) -> void`**  
  Adds a new item (e.g., a unit or building) to the production queue if there is available space.  
  - **Parameters**:  
    - `item`: The `PackedScene` representing the entity to be produced.  
  - **Returns**: `void`.  

- **`start_production() -> void`**  
  Begins the production process for the first item in the queue. If production is already in progress, this method does nothing.  

- **`_on_production_complete() -> void`**  
  Internal method called when production is complete. Removes the first item from the queue, instantiates the produced item, and emits the `production_complete` event.

- **`remove_from_queue(item: PackedScene) -> void`**  
  Removes a specific item from the queue, if present.  

- **`clear_queue() -> void`**  
  Clears all items from the queue and stops any ongoing production.  

- **`process(delta: float) -> void`**  
  Updates the production timer during the `_process` loop.  

## **Properties**

- **`@export var max_queue_size: int = 5`**  
  The maximum number of items that can be added to the queue.  

- **`@export var production_time: float = 5.0`**  
  The time required to produce each item.  

- **`var production_queue: Array = []`**  
  The current queue of items waiting to be produced.  

- **`var current_production_time: float = 0.0`**  
  Tracks the remaining time for the current production process.

## **Events**

- **`queue_updated(queue: Array)`**  
  Emitted whenever the queue is updated (e.g., an item is added or removed).  
  - **Parameters**:  
    - `queue`: The updated list of items in the queue.  

- **`production_complete(produced_item: BaseEntity)`**  
  Emitted when an item is successfully produced.  
  - **Parameters**:  
    - `produced_item`: The instantiated entity created from the `PackedScene`.  

## **Dependencies**

- None directly.  
- This component can function independently but is typically attached to a `BuildingEntity` or similar system that requires queue management for production.

## **Code**

[Source code](../../addons/rts_framework/scripts/components/queue_component.gd)
