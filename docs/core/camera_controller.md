# CameraController

The `CameraController` manages the movement, zoom, and rotation of the game camera. It allows players to navigate the map using the mouse and keyboard and adjust the camera’s zoom level for better visibility.

## **Class**

- **Base node/class**: `Node`
- **Class name**: `CameraController`

## **Methods**

- `handle_movement(delta: float) -> void`: Handles camera movement based on keyboard input or mouse position near the screen edges.
- `handle_zoom(event: InputEvent) -> void`: Adjusts the camera's zoom level based on scroll wheel input.
- `set_bounds(bounds: Rect2) -> void`: Sets the camera movement limits to ensure it stays within the game map.
- `_on_focus_on_position(position: Vector3) -> void`: Moves the camera to focus on the specified position.

## **Properties**

- `@export var move_speed: float = 15.0`: The speed of camera movement.
- `@export var zoom_speed: float = 0.25`: The speed of zoom adjustments.
- `@export var min_zoom: float = 45.0`: The minimum zoom level (closer to the ground).
- `@export var max_zoom: float = 75.0`: The maximum zoom level (further from the ground).
- `@onready var camera: Camera3D`: Reference to the active `Camera3D` node.
- `var move_margin: int = 20`: The screen margin within which mouse movement triggers camera movement.
- `var bounds: Rect2 = Rect2(-1000, -1000, 2000, 2000)`: The movement bounds for the camera.

## Signals

- None. The `CameraController` operates independently.

## **Dependencies**

- **Camera3D**: The component directly manipulates a `Camera3D` node for movement and zoom.

## Code

```gdscript
extends Node
class_name CameraController

@export var move_speed: float = 15.0
@export var zoom_speed: float = 0.25
@export var min_zoom: float = 45.0
@export var max_zoom: float = 75.0

@onready var camera: Camera3D = $Camera3D

var move_margin: int = 20
var bounds: Rect2 = Rect2(-1000, -1000, 2000, 2000)

func _ready() -> void:
    # Optionally connect to RTSController signals
    var rts_controller = get_tree().get_root().find_node("RTSController", recursive = true)
    if rts_controller:
        rts_controller.connect("focus_on_position", self, "_on_focus_on_position")

func _process(delta: float) -> void:
    handle_movement(delta)

func _input(event: InputEvent) -> void:
    handle_zoom(event)

func handle_movement(delta: float) -> void:
    var move_vec: Vector3 = Vector3()
    var mouse_pos = get_viewport().get_mouse_position()
    var viewport_size = get_viewport().size

    # Keyboard input for movement
    if Input.is_action_pressed("ui_left"):
        move_vec.x -= 1
    if Input.is_action_pressed("ui_right"):
        move_vec.x += 1
    if Input.is_action_pressed("ui_up"):
        move_vec.z -= 1
    if Input.is_action_pressed("ui_down"):
        move_vec.z += 1

    # Mouse edge movement
    if mouse_pos.x < move_margin:
        move_vec.x -= 1
    elif mouse_pos.x > viewport_size.x - move_margin:
        move_vec.x += 1
    if mouse_pos.y < move_margin:
        move_vec.z -= 1
    elif mouse_pos.y > viewport_size.y - move_margin:
        move_vec.z += 1

    # Rotate movement vector to match camera orientation
    move_vec = move_vec.rotated(Vector3.UP, camera.rotation.y)

    # Apply movement and keep the camera within bounds
    var new_pos = camera.global_transform.origin + move_vec * move_speed * delta
    new_pos.x = clamp(new_pos.x, bounds.position.x, bounds.position.x + bounds.size.x)
    new_pos.z = clamp(new_pos.z, bounds.position.y, bounds.position.y + bounds.size.y)
    camera.global_transform.origin = new_pos

func handle_zoom(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_WHEEL_UP:
            camera.fov = lerp(camera.fov, min_zoom, zoom_speed)
        elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
            camera.fov = lerp(camera.fov, max_zoom, zoom_speed)

func set_bounds(new_bounds: Rect2) -> void:
    bounds = new_bounds

func _on_focus_on_position(position: Vector3) -> void:
    camera.global_transform.origin = position
```