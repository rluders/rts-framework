# DamageableComponent

The `DamageableComponent` manages an entity's health, handling damage, healing, and destruction logic. It supports events to notify when the entity takes damage, is healed, or is destroyed. This component can be used for units, buildings, and other destructible entities.

## **Class**

- **Base node/class**: `Node`
- **Class name**: `DamageableComponent`

## **Methods**

- `apply_damage(amount: int) -> void`: Reduces the entity's health by the specified amount. Emits `damaged` and `destroyed` events as appropriate.
- `heal(amount: int) -> void`: Increases the entity's health by the specified amount, up to the maximum health. Emits the `healed` event.

## **Properties**

- `@export var max_health: int = 100`: The maximum health of the entity.
- `@export var is_repairable: bool = true`: Determines whether the entity can be repaired (or healed).
- `var current_health: int`: Tracks the entity’s current health level, initialized to `max_health`.

## **Events**

- `damaged(amount: int)`: Emitted when the entity takes damage.
- `healed(amount: int)`: Emitted when the entity is healed.
- `destroyed()`: Emitted when the entity's health reaches 0.

## **Dependencies**

- None directly. This component is standalone but is often paired with game logic to handle visual feedback (e.g., destruction animations).

## Code

```gdscript
extends Node
class_name DamageableComponent

signal damaged(amount: int)
signal healed(amount: int)
signal destroyed()

@export var max_health: int = 100
@export var is_repairable: bool = true
var current_health: int = max_health

func apply_damage(amount: int) -> void:
    current_health -= amount
    emit_signal("damaged", amount)
    if current_health <= 0:
        emit_signal("destroyed")

func heal(amount: int) -> void:
    if is_repairable:
        current_health = min(current_health + amount, max_health)
        emit_signal("healed", amount)
```