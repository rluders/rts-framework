extends Node
class_name CameraController

@export var move_speed: float = 15.0
@export var zoom_speed: float = 0.25
@export var min_zoom: float = 45.0
@export var max_zoom: float = 75.0
@export var camera: Camera3D
@export var move_margin: int = 100

var mouse_present : bool = true
var bounds: Rect2 = Rect2(-300, -300, 300, 300)

func _ready() -> void:
	var window : Window = get_tree().root.get_window()
	window.mouse_entered.connect(func(): mouse_present = true)
	window.mouse_exited.connect(func(): mouse_present = false)

func _process(delta: float) -> void:
	handle_movement(delta)

func _input(event: InputEvent) -> void:
	handle_zoom(event)

func handle_movement(delta: float) -> void:
	if not mouse_present:
		return
	
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
