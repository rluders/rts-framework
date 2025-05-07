@icon("res://addons/rts_framework/features/vision/minimap_icon.svg")
extends TextureRect
## Minimap that displays terrain and unit locations, integrating with the fog of war system
## 
## This class manages a minimap UI element that shows the game world from a top-down view.
## It displays unit positions and integrates with the fog of war system to show visible areas.
class_name Minimap

const DynamicCircle2D : PackedScene = preload("res://addons/rts_framework/features/vision/dynamic_circle_2d.tscn")

@export var vision_manager : VisionManager

var _vision_data : Dictionary

## Texture representing the fog of war alpha layer
##
## This texture is obtained from fog of war calculations and is multiplied over 
## the background of the minimap to create the fog of war effect, controlling
## what areas are visible to the player.
var fog_texture : Texture2D : # fog_texture multiply the images above. This to force what is seen and what not according to fog of war
	set(value):
		var fog_node = find_child("FogOfWarTexture")
		if fog_node && fog_node is TextureRect:
			var texture_rect = fog_node as TextureRect
			texture_rect.texture = value
		else:
			push_error("FogOfWarTexture node not found in Minimap. Minimap Node Name: " + self.name)
	get:
		var fog_node = find_child("FogOfWarTexture")
		if fog_node &&  fog_node is TextureRect:
			var texture_rect = fog_node as TextureRect
			return texture_rect.texture
		return null

@onready var _minimap_viewport: SubViewport = find_child("CombinedViewport") as SubViewport
 
func _ready() -> void:
	assert(vision_manager != null, "Minimap missing vision manager node. Minimap Node Name: " + self.name)
	var fog_texture_result = vision_manager.get_fog_texture()
	if fog_texture_result:
		fog_texture = fog_texture_result
	else:
		push_error("Failed to retrieve fog of war texture. Minimap Node Name: " + self.name)
	_vision_data = vision_manager.get_vision_data()
	if _vision_data == null:
		push_error("VisionManager returned null vision data for minimap: " + self.name)
		set_physics_process(false) # Disable physics processing to prevent runtime errors
		return # Abort further initialisation – minimap cannot function without data
	
	if not Engine.is_editor_hint():
		var circle = find_child("EditorOnlyCircle")
		if circle:
			circle.queue_free()

func _physics_process(_delta : float) -> void:
	for unit in _vision_data.keys():
		if not unit.is_revealing():
			continue
		if not _unit_is_minimap_mapped(unit):
			_map_unit_to_new_circles_body(unit)

func _unit_is_minimap_mapped(unit : BaseEntity) -> bool:
	if _vision_data != null:
		if unit in _vision_data:
			return _vision_data[unit].minimap_circle != null # If unit has minimap_circle
	return false

## Creates visibility representation for a unit on the minimap
## Parameters:
## - unit: The entity to create visibility for
## - default_color: The default color of the visibility circle
## - default_radius: The default radius of visibility
func _map_unit_to_new_circles_body(unit : BaseEntity, default_color : Color = Color.BLUE, default_radius : int = 5) -> void:
	if _vision_data != null:
		var minimap_circle = DynamicCircle2D.instantiate() # Make a white circle 2D
		
		if unit.has_method("get_team_color"): # If unit has get_team_color, use that color
			minimap_circle.color = unit.get_team_color()
		else: # if doesn't have the function, use the default one
			minimap_circle.color = default_color # Set color
		
		if unit.has_method("get_sight_range"):  # Set circle size to world units and unit sight range
			minimap_circle.radius = unit.get_sight_range() # If has sight range, then use it
		else:
			minimap_circle.radius = default_radius # If doesn't have sight range, then use default
		
		draw_node_on_minimap(minimap_circle) # Add the view circle 2D to fog of war viewport. In the fog of war viewport it create an image for the fog of war.
		
		_vision_data[unit].minimap_circle = minimap_circle # Keep map to connect unit with fog of war view
		# place at the correct coordinates straight away
		_vision_data[unit].sync_position(vision_manager.texture_units_per_world_unit)

## Addes draw_node(:CanvasItem) in way to draw it over other (preview) things in the minimap
##
## Return true on success, false on fail
func draw_node_on_minimap(draw_node : CanvasItem) -> bool:
	if _minimap_viewport:
		_minimap_viewport.add_child(draw_node)
		return true
	return false
