# Entities

Entities are the primary building blocks of the game world. They represent units, buildings, resources, and other in-game objects. Each entity can be enhanced by attaching modular components.

- [BaseEntity](./base_entity.md): A generic class for all game entities.
- [UnitEntity](./unit_entity.md): Represents movable units (e.g., soldiers, tanks).
- [BuildingEntity](./building_entity.md): Represents structures (e.g., barracks, resource depots).
- [ResourceEntity](./resource_entity.md): Represents resource nodes (e.g., gold, wood).

## Diagrams

```mermaid
classDiagram
    class BaseEntity {
        +int team
        +bool is_active
        +get_component(component_class: String) Node
    }
    class SelectableComponent {
        +select() void
        +deselect() void
        +set_selection_color(color: Color) void
    }
    class DamageableComponent {
        +apply_damage(amount: int) void
        +heal(amount: int) void
    }
    class CollectableComponent {
        +collect(amount: int) int
        +get_remaining_resources() int
    }
    class QueueComponent {
        +add_to_queue(item: PackedScene) void
        +start_production() void
    }
    BaseEntity o-- SelectableComponent
    BaseEntity o-- DamageableComponent
    BaseEntity o-- CollectableComponent
    BaseEntity o-- QueueComponent
```