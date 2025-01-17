extends CameraController

@export var rts_controller : RTSController

func _ready() -> void:
	super()
	# Connect to RTSController
	if rts_controller:
		rts_controller.focus_on_position.connect(_on_focus_on_position)

func _on_focus_on_position(position: Vector3) -> void:
	camera.global_transform.origin = position
