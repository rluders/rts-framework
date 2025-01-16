extends Node3D
class_name Raycaster

const RAY_LENGTH : int = 1000

var camera : Camera3D

func _ready() -> void:
	camera = get_parent().camera

func get_unit_under_mouse(team: int):
	var result = perform_raycast(2) # Layer for units
	if result and "team" in result.collider and result.collider.team == team:
		return result.collider
	return null

func get_ground_target():
	var result = perform_raycast(0b100111) # Example collision mask for surfaces
	if result.collider and result.collider.is_in_group("surface"):
		return result.position
	return null

func perform_raycast(collision_mask: int) -> Dictionary:
	var m_pos = get_viewport().get_mouse_position()
	var ray_start : Vector3 = camera.project_ray_origin(m_pos)
	var ray_end : Vector3 = ray_start + camera.project_ray_normal(m_pos) * RAY_LENGTH
	var space_state = get_world_3d().direct_space_state

	var prqp := PhysicsRayQueryParameters3D.new()
	prqp.from = ray_start
	prqp.to = ray_end
	prqp.collision_mask = collision_mask

	return space_state.intersect_ray(prqp)

func world_to_screen(world_pos: Vector3) -> Vector2:
	return get_viewport().get_camera_3d().unproject_position(world_pos)
