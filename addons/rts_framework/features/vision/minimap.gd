@icon("res://addons/rts_framework/features/vision/minimap_icon.svg")
extends TextureRect
## Minimap that displays terrain and unit locations, integrating with the fog of war system
## 
## This class manages a minimap UI element that shows the game world from a top-down view.
## It displays unit positions and integrates with the fog of war system to show visible areas.
class_name Minimap

const DynamicCircle2D : PackedScene = preload("res://addons/rts_framework/features/vision/dynamic_circle_2d.tscn")

@export var _fog_of_war_manager : FogOfWarManager

var _unit_to_circles_mapping : Dictionary = {}
var fog_texture : Texture2D :
	set(value):
		var fog_node = find_child("FogOfWarTexture")
		if fog_node:
			fog_node.texture = value
		else:
			push_error("FogOfWarTexture node not found")
	get:
		var fog_node = find_child("FogOfWarTexture")
		if fog_node:
			return fog_node.texture
		return null

@onready var _minimap_viewport = find_child("CombinedViewport")
 
func _ready() -> void:
	assert(_fog_of_war_manager != null, "Minimap missing fog of war manager node")
	var fog_texture_result = _fog_of_war_manager._combined_viewport.get_texture()
	if fog_texture_result:
		fog_texture = fog_texture_result
	else:
		push_error("Failed to retrieve fog of war texture")
	find_child("EditorOnlyCircle").queue_free()

func _physics_process(_delta : float) -> void:
	var units_synced = {}
	var units_to_sync = _fog_of_war_manager.get_visibile_unit()
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

func _unit_is_mapped(unit : BaseEntity) -> bool:
	return unit in _unit_to_circles_mapping

## Creates visibility representation for a unit on the minimap
## Parameters:
## - unit: The entity to create visibility for
## - color: Color of the visibility circle (default: unit's team color if available, or blue)
## - radius: Radius of visibility in world units (default: unit's sight range if available, or 5)
func _map_unit_to_new_circles_body(unit : BaseEntity, color : Color = Color.BLUE, radius : int = 5) -> void:
	var minimap_circle = DynamicCircle2D.instantiate() # Make a white circle 2D
	minimap_circle.color = color # Set color
	minimap_circle.radius = radius  # Set circle size to world units and unit sight range
	_minimap_viewport.add_child(minimap_circle) # Add the view circle 2D to fog of war viewport. In the fog of war viewport it create an image for the fog of war.
	_unit_to_circles_mapping[unit] = minimap_circle # Keep map to connect unit with fog of war view

func _sync_vision_to_unit(unit : BaseEntity) -> void:
	var unit_pos_3d = unit.global_transform.origin
	var unit_pos_2d = Vector2(unit_pos_3d.x, unit_pos_3d.z)  * _fog_of_war_manager.texture_units_per_world_unit
	_unit_to_circles_mapping[unit].position = unit_pos_2d

func _cleanup_mapping(unit : BaseEntity) -> void:
	_unit_to_circles_mapping[unit].queue_free()
	_unit_to_circles_mapping.erase(unit)

func _exit_tree() -> void:
	# Clean up all remaining circles
	for unit in _unit_to_circles_mapping.keys():
		_cleanup_mapping(unit)
	_unit_to_circles_mapping.clear()
