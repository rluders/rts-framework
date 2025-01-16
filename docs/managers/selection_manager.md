# SelectionManager

The `SelectionManager` is responsible for handling the selection and deselection of units. It manages the UI for drawing a selection rectangle, calculates which units are inside the rectangle, and emits events when units are selected or deselected.

## **Class**

- **Base node/class**: `Node`
- **Class name**: `SelectionManager`

## **Methods**

- `start_selection(start_pos: Vector2) -> void`: Initiates the selection process, setting the starting position of the selection rectangle.
- `update_selection(current_pos: Vector2) -> void`: Updates the selection rectangle during the drag operation.
- `end_selection(end_pos: Vector2) -> void`: Finalizes the selection, determines which units are inside the rectangle, and emits the `units_selected` event.
- `deselect_all() -> void`: Clears the current selection and emits an empty `units_selected` event.

## **Properties**

- `var selected_units: Array`: Stores the list of currently selected units.
- `var start_sel_pos: Vector2`: Stores the starting position of the selection rectangle.
- `var end_sel_pos: Vector2`: Stores the ending position of the selection rectangle.
- `var is_dragging: bool`: Indicates whether the user is currently dragging to create a selection rectangle.
- `@export var selection_box: ColorRect`: A UI element (typically a transparent rectangle) used to visually display the selection rectangle.

## **Events**

- `units_selected(units: Array)`: Emitted when the selection process is completed, sending the list of selected units.

## **Dependencies**

- **Raycaster**: Used to detect which units are under the mouse or within the selection rectangle.
- **RTSController**: Typically listens to `units_selected` events for further processing.

## Code

```gdscript
extends Node
class_name SelectionManager

signal units_selected(units: Array)

@export var selection_box: ColorRect

var selected_units: Array = []
var start_sel_pos: Vector2 = Vector2.ZERO
var end_sel_pos: Vector2 = Vector2.ZERO
var is_dragging: bool = false

func start_selection(start_pos: Vector2) -> void:
    start_sel_pos = start_pos
    is_dragging = true
    selection_box.visible = true
    selection_box.position = start_pos
    selection_box.size = Vector2.ZERO

func update_selection(current_pos: Vector2) -> void:
    if is_dragging:
        end_sel_pos = current_pos
        var rect = Rect2(start_sel_pos, end_sel_pos - start_sel_pos).abs()
        selection_box.position = rect.position
        selection_box.size = rect.size

func end_selection(end_pos: Vector2) -> void:
    if is_dragging:
        is_dragging = false
        selection_box.visible = false
        end_sel_pos = end_pos
        var rect = Rect2(start_sel_pos, end_sel_pos - start_sel_pos).abs()
        selected_units = get_units_in_rect(rect)
        emit_signal("units_selected", selected_units)

func deselect_all() -> void:
    selected_units.clear()
    emit_signal("units_selected", [])

func get_units_in_rect(rect: Rect2) -> Array:
    var units = []
    for unit in get_tree().get_nodes_in_group("units"):
        var unit_screen_pos = Raycaster.world_to_screen(unit.global_transform.origin)
        if rect.has_point(unit_screen_pos):
            units.append(unit)
    return units

```