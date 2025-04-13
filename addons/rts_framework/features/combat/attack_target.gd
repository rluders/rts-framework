extends Resource
class_name AttackTarget

## Is type UnitEntity or Vector3
var target : 
	set(value):
		# Reset values
		_target_unit = null
		_target_point = Vector3.INF
		if value is UnitEntity:
			_target_unit = value
		elif value is Vector3:
			_target_point = value
	get:
		if _target_unit == null:
			return _target_point
		return _target_unit
var _target_unit : UnitEntity = null
var _target_point : Vector3 = Vector3.INF

func get_target_position() -> Vector3:
	if target is UnitEntity && target != null: #_target_unit
		return target.global_position
	return target #_target_point

func has_target() -> bool:
	return (target != null && target != Vector3.INF)

func get_target_unit() -> UnitEntity:
	return _target_unit
