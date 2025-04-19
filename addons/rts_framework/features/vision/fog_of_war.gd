@tool
extends MeshInstance3D
class_name FogOfWarManager

@export var vision_manager : VisionManager:
	set(value):
		_vision_manager = value
		if _vision_manager:
			_apply_fog_texture_from_vision_manager()
	get:
		return _vision_manager

# Private backing field
var _vision_manager : VisionManager

@export_category("Fog Values")

## The size of a single pixel in the 3D world
var _texture_units_per_world_unit: int = 2
@export_range(1, 10000, 1,"suffix:px/length") var texture_units_per_world_unit : int = 2 : # px/length
	set(value):
		if material_override:
			material_override.set_shader_parameter("texture_units_per_world_unit", value)
		_texture_units_per_world_unit = value
	get:
		return _texture_units_per_world_unit

## Color of the generated fog
@export var fog_color : Color :
	set(value):
		if material_override:
			material_override.set_shader_parameter("color", value)
	get:
		return material_override.get_shader_parameter("color")
## TODO add description for outer_margin_for_fade_out.
@export var outer_margin_for_fade_out : float :
	set(value):
		if material_override:
			material_override.set_shader_parameter("outer_margin_for_fade_out", value)
	get:
		return material_override.get_shader_parameter("outer_margin_for_fade_out")

@export_category("Debug Values")
## Shows small texture of the fog
@export var debug_texture_view : bool = false:
	set(value):
		if material_override:
			material_override.set_shader_parameter("debug_texture_view", value)
	get:
		return material_override.get_shader_parameter("debug_texture_view")
## Shows small texture of the fog
@export_range(0, 1) var debug_texture_view_size : float = 0.2:
	set(value):
		if material_override:
			material_override.set_shader_parameter("debug_texture_view_size", value)
	get:
		return material_override.get_shader_parameter("debug_texture_view_size")

# Private backing field to store the texture
var _fog_texture : ViewportTexture
var fog_texture : ViewportTexture:
	set(value):
		_fog_texture = value # Store in backing field
		if material_override: # Check if material exists
			material_override.set_shader_parameter("world_visibility_texture", value)
	get:
		return _fog_texture # Return from backing field


func _ready() -> void:
	if vision_manager:
		await vision_manager.ready
		var fog_texture_result = vision_manager.get_fog_texture()
		if fog_texture_result:
			fog_texture = fog_texture_result
	else:
		push_warning("FogOfWarManager: 'vision_manager' is not assigned – fog texture cannot be applied.")

func _apply_fog_texture_from_vision_manager() -> void:
	if _vision_manager == null:
		return
	var fog_texture_result = _vision_manager.get_fog_texture()
	if fog_texture_result:
		fog_texture = fog_texture_result
