extends RTSController

signal focus_on_position(position: Vector3)

func _ready() -> void:
	Raycaster.camera = get_viewport().get_camera_3d()
	connect_events()

func connect_events() -> void:
	pass
	#selection_manager.units_selected.connect(_on_units_selected)
	#command_manager.command_issued.connect(_on_command_issued)

func _on_units_selected(units: Array) -> void:
	print("RTSController: Units selected:", units)
	focus_camera_on_units(units)

func focus_camera_on_units(units: Array) -> void:
	if units.size() > 0:
		var avg_position = Vector3.ZERO
		for unit in units:
			avg_position += unit.global_transform.origin
		avg_position /= units.size()
		emit_signal("focus_on_position", avg_position)
