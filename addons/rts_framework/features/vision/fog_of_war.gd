@tool
extends MeshInstance3D
class_name FogOfWarManager
@export var vision_manager : VisionManager:
	set(value):
		vision_manager = value
		var fog_texture_result = value.get_fog_texture()
		if fog_texture_result:
			fog_texture = fog_texture_result
	get:
		return vision_manager

@export_category("Fog Values")

## The size of a single pixel in the 3D world
@export_range(1, 10000, 1,"suffix:px/length") var texture_units_per_world_unit : int = 2 : # px/length
		set(value):
			material_override.set_shader_parameter("texture_units_per_world_unit", value)
			texture_units_per_world_unit = value

## Color of the generated fog
@export var fog_color : Color :
	set(value):
		material_override.set_shader_parameter("color", value)
	get:
		return material_override.get_shader_parameter("color")
## TODO add description for outer_margin_for_fade_out.
@export var outer_margin_for_fade_out : float :
	set(value):
		material_override.set_shader_parameter("outer_margin_for_fade_out", value)
	get:
		return material_override.get_shader_parameter("outer_margin_for_fade_out")

@export_category("Debug Values")
## Shows small texture of the fog
@export var debug_texture_view : bool = false:
	set(value):
		material_override.set_shader_parameter("debug_texture_view", value)
	get:
		return material_override.get_shader_parameter("debug_texture_view")
## Shows small texture of the fog
@export_range(0, 1) var debug_texture_view_size : float = 0.2:
	set(value):
		material_override.set_shader_parameter("debug_texture_view_size", value)
	get:
		return material_override.get_shader_parameter("debug_texture_view_size")

var fog_texture : ViewportTexture:
	set(value):
		material_override.set_shader_parameter("world_visibility_texture", value)
	get:
		return material_override.get_shader_parameter("world_visibility_texture")


func _ready() -> void:
	await vision_manager
	var fog_texture_result = vision_manager.get_fog_texture()
	if fog_texture_result:
		fog_texture = fog_texture_result
