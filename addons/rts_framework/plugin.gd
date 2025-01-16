@tool
extends EditorPlugin

func _enter_tree() -> void:
	# Components
	add_custom_type(
		"CollectableComponent",
		"Node3D",
		preload("res://addons/rts_framework/components/collectable_component.gd"),
		null
	)
	add_custom_type(
		"DamageableComponent",
		"Node3D",
		preload("res://addons/rts_framework/components/damageable_component.gd"),
		null
	)
	add_custom_type(
		"QueueComponent",
		"Node3D",
		preload("res://addons/rts_framework/components/queue_component.gd"),
		null
	)
	add_custom_type(
		"SelectableComponent",
		"Node3D",
		preload("res://addons/rts_framework/components/selectable_component.gd"),
		null
	)
	
	# Core
	add_custom_type(
		"CameraController",
		"Node3D",
		preload("res://addons/rts_framework/core/camera_controller.gd"),
		null
	)
	add_custom_type(
		"ConstructionManager",
		"Node",
		preload("res://addons/rts_framework/core/construction_manager.gd"),
		null
	)
	add_custom_type(
		"Raycaster",
		"Node3D",
		preload("res://addons/rts_framework/core/raycaster.gd"),
		null
	)
	add_custom_type(
		"RTSController",
		"Node",
		preload("res://addons/rts_framework/core/rts_controller.gd"),
		null
	)
	
	# Entities
	add_custom_type(
		"BaseEntity",
		"Node3D",
		preload("res://addons/rts_framework/entities/base_entity.gd"),
		null
	)
	add_custom_type(
		"BuildingEntity",
		"Node3D",
		preload("res://addons/rts_framework/entities/building_entity.gd"),
		null
	)
	add_custom_type(
		"ResourceEntity",
		"Node3D",
		preload("res://addons/rts_framework/entities/resource_entity.gd"),
		null
	)
	add_custom_type(
		"UnitEntity",
		"Node3D",
		preload("res://addons/rts_framework/entities/unit_entity.gd"),
		null
	)
	
	# Managers
	add_custom_type(
		"CommandManager",
		"Node3D",
		preload("res://addons/rts_framework/managers/command_manager.gd"),
		null
	)
	add_custom_type(
		"SelectionManager",
		"Node3D",
		preload("res://addons/rts_framework/managers/selection_manager.gd"),
		null
	)
	
	# States
	add_custom_type(
		"State",
		"Node",
		preload("res://addons/rts_framework/states/state.gd"),
		null
	)
	add_custom_type(
		"StateMachine",
		"Node",
		preload("res://addons/rts_framework/states/state_machine.gd"),
		null
	)

func _exit_tree() -> void:
	# Components
	remove_custom_type("CollectableComponent")
	remove_custom_type("DamageableComponent")
	remove_custom_type("QueueComponent")
	remove_custom_type("SelectableComponent")
	
	# Core
	remove_custom_type("CameraController")
	remove_custom_type("ConstructionManager")
	remove_custom_type("Raycaster")
	remove_custom_type("RTSController")
	
	# Entities
	remove_custom_type("BaseEntity")
	remove_custom_type("BuildingEntity")
	remove_custom_type("ResourceEntity")
	remove_custom_type("UnitEntity")
	
	# Managers
	remove_custom_type("CommandManager")
	remove_custom_type("SelectionManager")
	
	# States
	remove_custom_type("State")
	remove_custom_type("StateMachine")
