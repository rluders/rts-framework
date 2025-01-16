# UnitEntity

The `UnitEntity` represents movable and interactable units in the game, such as soldiers, tanks, or workers. It inherits from `BaseEntity` and utilizes a `StateMachine` to manage behaviors like movement, attacking, building, or collecting resources.

## **Class**

- **Base node/class**: `BaseEntity`
- **Class name**: `UnitEntity`

## **Methods**

- `move_to(target_position: Vector3) -> void`: Instructs the unit to move to a specified position, transitioning its `StateMachine` to the `MoveState`.
- `attack(target: BaseEntity) -> void`: Sets the target for an attack and transitions the `StateMachine` to the `AttackState`.
- `build(target_position: Vector3, scene: PackedScene) -> void`: Commands the unit to build a structure at the specified position, transitioning to the `BuildState`.
- `collect(resource: BaseEntity) -> void`: Commands the unit to collect resources from a target, transitioning to the `CollectState`.

## **Properties**

- `@onready var state_machine: StateMachine = $StateMachine`: The state machine that manages the unit’s behaviors.
- `@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D`: The navigation agent used for pathfinding and movement.

## **Events**

- None. The unit relies on the `StateMachine` and components for event-driven behavior.

## **Dependencies**

- **StateMachine**: Required to handle transitions between states such as moving, attacking, or collecting.
- **NavigationAgent3D**: Required for movement and pathfinding.
- **Components**: Optional components such as `SelectableComponent` or `DamageableComponent`.

## Code

```gdscript
extends BaseEntity
class_name UnitEntity

@onready var state_machine: StateMachine = $StateMachine
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

func move_to(target_position: Vector3) -> void:
    var move_state = state_machine.states.get("move")
    if move_state:
        move_state.set_target(target_position)
        state_machine.transition_to("move")

func attack(target: BaseEntity) -> void:
    var attack_state = state_machine.states.get("attack")
    if attack_state:
        attack_state.set_target(target)
        state_machine.transition_to("attack")

func build(target_position: Vector3, scene: PackedScene) -> void:
    var build_state = state_machine.states.get("build")
    if build_state:
        build_state.set_construction(scene, target_position)
        state_machine.transition_to("build")

func collect(resource: BaseEntity) -> void:
    var collect_state = state_machine.states.get("collect")
    if collect_state:
        collect_state.set_target(resource)
        state_machine.transition_to("collect")
```