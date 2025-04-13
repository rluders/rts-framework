extends Resource
class_name ProjectileData

## The projectile scene which will be instantiated
@export var projectile_scene : PackedScene

@export_subgroup("Tween Values")
## The maximum speed the projectile gets
@export var final_speed : int:
	set(value):
		final_speed = max(0, value)
	get:
		return final_speed
## Duration it takes for the projectile to get to maximum speed
@export var duration_to_final_speed : int:
	set(value):
		duration_to_final_speed = max(0, value)
	get:
		return duration_to_final_speed
## The tween transition type for speed
@export var tween_transition_type_speed : Tween.TransitionType = Tween.TRANS_EXPO
## The tween ease type for speed
@export var tween_ease_type_speed : Tween.EaseType = Tween.EASE_IN

## Is type UnitEntity or Vector3
var target : 
	set(value):
		# Reset values
		_target_unit = null
		_target_point = Vector3.INF
		if value is UnitEntity:
			_target_unit
		elif value is Vector3:
			_target_point = value
	get:
		if _target_unit == null:
			return _target_point
		return _target_unit

var _target_unit : UnitEntity = null
var _target_point : Vector3 = Vector3.INF

func projectile_instantiate(start_position : Vector3) -> Node3D:
	if projectile_scene == null:
		push_error("ProjectileData: projectile_scene is null")
		return null

	var projectile : Node3D = projectile_scene.instantiate() as Node3D
	projectile.position = start_position
		
	var projectile_tween : Tween = projectile.create_tween()
	projectile_tween.tween_property(projectile, "speed", final_speed, duration_to_final_speed).set_trans(tween_transition_type_speed).set_ease(tween_ease_type_speed)
	return projectile

func projectile_can_instantiate() -> bool:
	if projectile_scene == null:
		return false
	return projectile_scene.can_instantiate()
