@tool
@icon("res://addons/rts_framework/features/vision/fog_of_war_icon.svg")
extends BaseManager
class_name FogOfWarManager

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
			find_child("ScreenOverlay").material_override.set_shader_parameter("texture_units_per_world_unit", value)
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
## Color of the generated fog
@export var fog_color : Color :
	set(value):
		find_child("ScreenOverlay").material_override.set_shader_parameter("color", value)
	get:
		return find_child("ScreenOverlay").material_override.get_shader_parameter("color")
## TODO add description for outer_margin_for_fade_out.
@export var outer_margin_for_fade_out : float :
	set(value):
		find_child("ScreenOverlay").material_override.set_shader_parameter("outer_margin_for_fade_out", value)
	get:
		return find_child("ScreenOverlay").material_override.get_shader_parameter("outer_margin_for_fade_out")

@export_category("Debug Values")
## Revels the whole fog.
@export var revel_fog : bool = false:
	set(value):
		find_child("Revealer").set_visible(value)
	get:
		return find_child("Revealer").is_visible()
## Shows small texture of the fog
@export var debug_texture_view : bool = false:
	set(value):
		find_child("ScreenOverlay").material_override.set_shader_parameter("debug_texture_view", value)
	get:
		return find_child("ScreenOverlay").material_override.get_shader_parameter("debug_texture_view")
## Shows small texture of the fog
@export_range(0, 1) var debug_texture_view_size : float = 0.2:
	set(value):
		find_child("ScreenOverlay").material_override.set_shader_parameter("debug_texture_view_size", value)
	get:
		return find_child("ScreenOverlay").material_override.get_shader_parameter("debug_texture_view_size")

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

#TODO Think if to merge both Dictionary or not
var _unit_to_circles_mapping : Dictionary = {}
var _unit_to_shape_3d_mapping : Dictionary = {}

@onready var _revealer : ColorRect = find_child("Revealer")
@onready var _fog_viewport : SubViewport = find_child("FogViewport")
@onready var _fog_viewport_container : SubViewportContainer = find_child("FogViewportContainer")
@onready var _combined_viewport : SubViewport = find_child("CombinedViewport")
@onready var _screen_overlay : MeshInstance3D = find_child("ScreenOverlay")
@onready var _visibility_field : Area3D = find_child("VisibilityField")

var combined_viewport  : SubViewport :
	get:
		return _combined_viewport as SubViewport

func _ready() -> void:
	_screen_overlay.material_override.set_shader_parameter(
		"texture_units_per_world_unit", texture_units_per_world_unit
	)
	if not Engine.is_editor_hint():
		_revealer.hide()
		var circle = find_child("EditorOnlyCircle")
		if circle:
			circle.queue_free()

func _physics_process(_delta : float) -> void:
	if not Engine.is_editor_hint(): # Code to execute when in game.
		var units_synced = {}
		var units_to_sync = get_tree().get_nodes_in_group("revealed_units")
		for unit in units_to_sync:
			if not unit.is_revealing():
				continue
			units_synced[unit] = 1
			if not _unit_is_mapped(unit):
				_map_unit_to_new_circles_body(unit)
			_sync_vision_to_unit(unit)
		for mapped_unit in _unit_to_circles_mapping:
			if not mapped_unit in units_synced:
				_cleanup_mapping(mapped_unit)
	else:
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
	return unit in _unit_to_circles_mapping


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
	_unit_to_circles_mapping[unit] = [shroud_circle, fow_circle] # Keep map to connect unit with fog of war view
	var visibility_shape_3d = VisibilityShape3D.instantiate() # Make a cylinder
	visibility_shape_3d.shape.radius = effective_sight_range  # Cylinder radius equal to sight range
	_visibility_field.add_child(visibility_shape_3d) # Add the shape to the VisibilityField(Area3D node type)
	_unit_to_shape_3d_mapping[unit] = visibility_shape_3d # Map unit and shape

func _sync_vision_to_unit(unit : BaseEntity) -> void:
	var unit_pos_3d = unit.global_transform.origin
	var unit_pos_2d = Vector2(unit_pos_3d.x, unit_pos_3d.z) * texture_units_per_world_unit
	_unit_to_circles_mapping[unit][0].position = unit_pos_2d
	_unit_to_circles_mapping[unit][1].position = unit_pos_2d
	_unit_to_shape_3d_mapping[unit].position = unit_pos_3d


func _cleanup_mapping(unit : BaseEntity) -> void:
	_unit_to_circles_mapping[unit][0].queue_free()
	_unit_to_circles_mapping[unit][1].queue_free()
	_unit_to_circles_mapping.erase(unit)
	_unit_to_shape_3d_mapping[unit].queue_free()
	_unit_to_shape_3d_mapping.erase(unit)


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
		
