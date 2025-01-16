# CommandManager

The `CommandManager` handles the execution of commands issued by the player. It supports flexible commands through context dictionaries, enabling diverse interactions such as movement, attacking, building, or collecting resources.

## **Class**

- **Base node/class**: `Node`
- **Class name**: `CommandManager`

## **Methods**

- `issue_command(units: Array, target: Variant, context: Dictionary) -> void`: Issues a command to a group of units, where the `target` can be a position (`Vector3`) or an entity (`BaseEntity`), and the `context` contains additional information about the command type and parameters.

## **Properties**

- None, as the `CommandManager` processes commands dynamically through method arguments.

## **Events**

- `command_issued(command: String, units: Array, target: Variant, context: Dictionary)`: Emitted whenever a command is issued, providing details of the command, target, and units.

## **Dependencies**

- **RTSController**: Connects to the `command_issued` event for centralized handling.
- **Units (UnitEntity)**: Each unit is expected to handle specific commands emitted by the `CommandManager`.

## Code

```gdscript
extends Node
class_name CommandManager

signal command_issued(command: String, units: Array, target: Variant, context: Dictionary)

func issue_command(units: Array, target: Variant, context: Dictionary) -> void:
    # Extract the command type from the context (default to "default")
    var command = context.get("command_type", "default")
    
    # Emit the event for all listeners, passing the command details
    emit_signal("command_issued", command, units, target, context)
    
    # Handle common commands directly
    match command:
        "move":
            for unit in units:
                unit.emit_signal("move_command", target)
        "attack":
            for unit in units:
                unit.emit_signal("attack_command", target)
        "build":
            for unit in units:
                unit.emit_signal("build_command", target, context)
        "collect":
            for unit in units:
                unit.emit_signal("collect_command", target)
        _:
            print("Unknown command type:", command)

```