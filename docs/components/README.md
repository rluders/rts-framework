# Components

Components are modular pieces of functionality that can be attached to entities. They allow for extending entity behavior without creating tightly coupled, monolithic systems.

- [SelectableComponent](./selectable_component.md): Enables entities to be selected and highlighted.
- [DamageableComponent](./damageable_component.md): Handles health, damage, and destruction logic.
- [CollectableComponent](./collectable_component.md): Manages resource collection for resource nodes.
- [QueueComponent](./queue_component.md): Manages production queues for buildings.

## Component Hierarchy

You can attach the componentes to any kind of Entity.

```bash
BaseEntity
├── SelectableComponent
├── DamageableComponent
└── QueueComponent
```