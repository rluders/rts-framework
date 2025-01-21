extends Node3D
class_name CameraController

@export var camera: Camera3D
@export var move_speed: float = 7.0  # Adjusted for smoother movement
@export var zoom_speed: float = 1.5
@export var min_zoom: float = 5.0
@export var max_zoom: float = 20.0
@export var rotation_sensitivity: float = 0.1  # Reduced for finer control
@export var edge_scroll_margin: int = 20
@export var tween_duration: float = 0.5
@export var map_bounds: Rect2 = Rect2(-100, -100, 200, 200)  # Define map bounds in world space

var current_zoom: float = 20.0
var rotating: bool = false
var last_mouse_position: Vector2
var window_focused: bool = true

func _ready() -> void:
	# Ensure the camera exists
	if not camera:
		camera = $Camera3D

	camera.fov = current_zoom

	# Update window focus status based on mouse enter and exit events
	var window: Window = get_tree().root.get_window()
	window.mouse_entered.connect(func(): window_focused = true)
	window.mouse_exited.connect(func(): window_focused = false)

func _process(delta: float) -> void:
	if not window_focused:
		return  # Skip updates if the window is not focused

	handle_movement(delta)
	handle_zoom(delta)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("camera_rotate"):
		rotating = true
		last_mouse_position = event.position
	elif event.is_action_released("camera_rotate"):
		rotating = false

	if event is InputEventMouseMotion and rotating:
		handle_mouse_rotation(event.relative)

# --- Movement ---
func handle_movement(delta: float) -> void:
	var move_vec = Vector3()

	# WASD/Arrow key movement
	if Input.is_action_pressed("ui_up"):
		move_vec.z -= 1
	if Input.is_action_pressed("ui_down"):
		move_vec.z += 1
	if Input.is_action_pressed("ui_left"):
		move_vec.x -= 1
	if Input.is_action_pressed("ui_right"):
		move_vec.x += 1

	# Edge scrolling
	var mouse_pos = get_viewport().get_mouse_position()
	var viewport_size = get_viewport().size

	if mouse_pos.x < edge_scroll_margin:
		move_vec.x -= 1
	elif mouse_pos.x > viewport_size.x - edge_scroll_margin:
		move_vec.x += 1

	if mouse_pos.y < edge_scroll_margin:
		move_vec.z -= 1
	elif mouse_pos.y > viewport_size.y - edge_scroll_margin:
		move_vec.z += 1

	# Normalize and apply movement vector
	if move_vec != Vector3.ZERO:
		move_vec = move_vec.normalized() * move_speed * delta
		move_vec = move_vec.rotated(Vector3.UP, rotation.y)
		position += move_vec
		clamp_to_map_bounds()

func clamp_to_map_bounds() -> void:
	var pos = position
	pos.x = clamp(pos.x, map_bounds.position.x, map_bounds.position.x + map_bounds.size.x)
	pos.z = clamp(pos.z, map_bounds.position.y, map_bounds.position.y + map_bounds.size.y)
	position = pos

# --- Zoom ---
func handle_zoom(delta: float) -> void:
	if Input.is_action_just_pressed("zoom_in"):
		zoom_to(current_zoom - zoom_speed)
	elif Input.is_action_just_pressed("zoom_out"):
		zoom_to(current_zoom + zoom_speed)

func zoom_to(target_zoom: float) -> void:
	target_zoom = clamp(target_zoom, min_zoom, max_zoom)
	var tween = get_tree().create_tween()
	tween.tween_property(camera, "fov", target_zoom, tween_duration)
	current_zoom = target_zoom

# --- Rotation ---
func handle_mouse_rotation(mouse_delta: Vector2) -> void:
	# Rotate only the Y-axis of the gimbal (this node)
	rotate_y(-mouse_delta.x * rotation_sensitivity)

# Smooth transition to a specific position
func move_to_position(target_position: Vector3) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", target_position, tween_duration)
