# Raycaster

The `Raycaster` is a singleton responsible for handling raycast operations in the game world. It provides methods to detect entities under the mouse cursor, find ground positions, and interact with specific layers or collision masks. It abstracts raycasting functionality for use across different systems, like selection, command issuing, and interactions.

## **Class**

- **Base node/class**: `Node`
- **Class name**: `Raycaster`

## **Methods**

- `get_unit_under_mouse() -> BaseEntity`: Detects and returns a unit entity under the mouse cursor, or `null` if none exists.
- `get_ground_position() -> Vector3`: Returns the world position on the ground where the mouse cursor is pointing.
- `raycast(collision_mask: int) -> Dictionary`: Performs a raycast based on a specified collision mask and returns the result dictionary (e.g., collider, position).

## **Properties**

- `camera: Camera3D` :  The current active camera in the game.

## Signals

- None. This component does not emit events directly.

## **Dependencies**

- **Camera3D**: It requires an active camera to calculate the ray’s origin and direction.
- **Collision layers**: It interacts with layers set for units, ground, and other objects.

## Code

```gdscript
extends Node3D
class_name Raycaster

const RAY_LENGTH: int = 1000

var camera: Camera3D

func _ready() -> void:
    if !camera:
        camera = get_viewport().get_camera_3d()

func get_unit_under_mouse() -> BaseEntity:
    var result = raycast(2)  # Assuming layer 2 is for units
    if result and "collider" in result:
        if result.collider is BaseEntity:
            return result.collider
    return null

func get_ground_position() -> Vector3:
    var result = raycast(1)  # Assuming layer 1 is for ground
    if result and "position" in result:
        return result.position
    return null

func raycast(collision_mask: int) -> Dictionary:
    if !camera:
        return {}
    var mouse_pos = get_viewport().get_mouse_position()
    var ray_origin = camera.project_ray_origin(mouse_pos)
    var ray_direction = camera.project_ray_normal(mouse_pos) * RAY_LENGTH
    var space_state = get_world_3d().direct_space_state

    var query = PhysicsRayQueryParameters3D.new()
    query.from = ray_origin
    query.to = ray_origin + ray_direction
    query.collision_mask = collision_mask

    return space_state.intersect_ray(query)
```