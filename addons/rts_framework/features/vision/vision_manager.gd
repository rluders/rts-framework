@tool
extends BaseManager
class_name VisionManager

const DynamicCircle2D : PackedScene = preload("res://addons/rts_framework/features/vision/dynamic_circle_2d.tscn")

const VisibilityShape3D : PackedScene  = preload("res://addons/rts_framework/features/vision/visibility_shape_3d.tscn")

const DEFAULT_SIZE : Vector2i = Vector2i(100, 100)

## Color of area the units saw and not seeing currenty. Can see in Debug Texture View
@export var fog_circle_color : Color = Color(0.25, 0.25, 0.25)
## Color of area the units see around them. Can see in Debug Texture View
@export var shroud_circle_color : Color = Color(1.0, 1.0, 1.0)
@export_category("Fog Values")

## The size of a single pixel in the 3D world
@export_range(1, 10000, 1,"suffix:px/length") var texture_units_per_world_unit : int = 2 : # px/length
		set(value):
			texture_units_per_world_unit = value

## AAA
@export var map_mesh_node : MeshInstance3D:
	set(value):
		map_mesh_node = value
		if map_mesh_node:
			if map_mesh_node.mesh:
				fog_size = value.mesh.size
## Size of the generated fog
@export var fog_size : Vector2i = DEFAULT_SIZE:
	set(value):
		var map_effective_size = value * texture_units_per_world_unit
		find_child("CombinedViewport").size = map_effective_size
		fog_size = value
	get:
		if map_mesh_node:
			if map_mesh_node.mesh:
				return map_mesh_node.mesh.size
		return fog_size

@export_category("Debug Values")
## Revels the whole fog.
@export var revel_fog : bool = false:
	set(value):
		find_child("Revealer").set_visible(value)
	get:
		return find_child("Revealer").is_visible()

@export_group("Editor Only Circle")
## TODO: Add description
@export var editor_only_circle_color : Color = Color.WHITE :
	set(value):
		find_child("EditorOnlyCircle").color = value
	get:
		return find_child("EditorOnlyCircle").color
## TODO: Add description
@export var editor_only_circle_radius : int = 25 :
	set(value):
		find_child("EditorOnlyCircle").radius = value
	get:
		return find_child("EditorOnlyCircle").radius
## TODO: Add description
@export var editor_only_circle_position : Vector2 = Vector2(30,30) :
	set(value):
		find_child("EditorOnlyCircle").position = value
	get:
		return find_child("EditorOnlyCircle").position

var _unit_to_vision_data : Dictionary = {}

@onready var _revealer : ColorRect = find_child("Revealer")
@onready var _fog_viewport : SubViewport = find_child("FogViewport")
@onready var _fog_viewport_container : SubViewportContainer = find_child("FogViewportContainer")
@onready var _combined_viewport : SubViewport = find_child("CombinedViewport")
@onready var _visibility_field : Area3D = find_child("VisibilityField")

# No set function, to prevent setting from outside
var combined_viewport  : SubViewport :
	get:
		return _combined_viewport as SubViewport

func _ready() -> void:
	if not Engine.is_editor_hint():
		_revealer.hide()
		var circle = find_child("EditorOnlyCircle")
		if circle:
			circle.queue_free()

func _physics_process(_delta : float) -> void:
	if not Engine.is_editor_hint(): # Code to execute when in game.
		var units_synced : Dictionary = {}
		var units_to_sync = get_tree().get_nodes_in_group("revealed_units")
		for unit in units_to_sync:
			if not unit.is_revealing():
				continue
			units_synced[unit] = 1
			if not _unit_is_mapped(unit):
				_map_unit_to_new_circles_body(unit)
			_sync_vision_to_unit(unit)
		for mapped_unit in _unit_to_vision_data:
			if not mapped_unit in units_synced:
				_cleanup_mapping(mapped_unit)
	else:
		update_configuration_warnings()
		if map_mesh_node: # If there is a map mesh, then update in editor the size
			if map_mesh_node.mesh:
				fog_size = map_mesh_node.mesh.size


func reveal() -> void:
	_revealer.show()


func resize(map_size: Vector2) -> void:
	var map_effective_size = map_size * texture_units_per_world_unit
	find_child("FogViewport").size = map_effective_size
	find_child("CombinedViewport").size = map_effective_size


func _unit_is_mapped(unit : BaseEntity) -> bool:
	return unit in _unit_to_vision_data


# Create a fog of war visibility circles and visibility shape 3d
func _map_unit_to_new_circles_body(unit : BaseEntity) -> void:
	var effective_sight_range = unit.sight_range * texture_units_per_world_unit;
	
	var shroud_circle = DynamicCircle2D.instantiate() # Make a white circle 2D
	shroud_circle.color = fog_circle_color # Set color
	shroud_circle.radius = effective_sight_range  # Set circle size to world units and unit sight range
	_fog_viewport.add_child(shroud_circle) # Add the view circle 2D to fog of war viewport. In the fog of war viewport it create an image for the fog of war.
	
	var fow_circle = DynamicCircle2D.instantiate()
	fow_circle.color = shroud_circle_color
	fow_circle.radius = effective_sight_range
	_fog_viewport_container.add_sibling(fow_circle)
	
	var visibility_shape_3d = VisibilityShape3D.instantiate() # Make a cylinder
	visibility_shape_3d.shape.radius = effective_sight_range  # Cylinder radius equal to sight range
	_visibility_field.add_child(visibility_shape_3d) # Add the shape to the VisibilityField(Area3D node type)
	
	#_unit_to_shape_3d_mapping[unit] = visibility_shape_3d # Map unit and shape
	#_unit_to_circles_mapping[unit] = [shroud_circle, fow_circle] # Keep map to connect unit with fog of war view
	#_unit_to_circles_mapping[unit] = [shroud_circle, fow_circle] # Keep map to connect unit with fog of war view
	
	_unit_to_vision_data[unit] = UnitVisionData.create(unit, fow_circle, shroud_circle, visibility_shape_3d)

func _sync_vision_to_unit(unit : BaseEntity) -> void:
	_unit_to_vision_data[unit].sync_position(texture_units_per_world_unit)


func _cleanup_mapping(unit : BaseEntity) -> void:
	_unit_to_vision_data.erase(unit)


func get_visible_units() -> Array[Node3D]:
	# Returns an array of visible UnitEntity objects within the fog of war visibility field
	var overlapping_bodies = _visibility_field.get_overlapping_bodies()
	return overlapping_bodies.filter(func(node3D):
		return node3D is UnitEntity
	)

# When a PhysicsBody3D enters the total field of vision
func _on_visibility_field_body_entered(body: Node3D) -> void:
	#print_debug("_on_visibility_field_body_entered")
	if body is UnitEntity:
		body.visible = true

# When a PhysicsBody3D exits the total field of vision
func _on_visibility_field_body_exited(body: Node3D) -> void:
	#print_debug("_on_visibility_field_body_exited")
	if body is UnitEntity:
		body.visible = false

func get_vision_data() -> Dictionary:
	return _unit_to_vision_data


func get_fog_texture() -> ViewportTexture:
	var fog_texture_result
	if combined_viewport:
		fog_texture_result = combined_viewport.get_texture()
	else:
		fog_texture_result = $CombinedViewport.get_texture()
	if fog_texture_result:
		return fog_texture_result
	return null

func _get_configuration_warnings() -> PackedStringArray:
	var warnings : Array[String] = []
	if fog_size == DEFAULT_SIZE:
		warnings.append("Fog of war size is default size")
	return warnings
