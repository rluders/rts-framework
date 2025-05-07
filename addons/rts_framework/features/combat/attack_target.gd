extends Resource
class_name AttackTarget

## Manages a target for combat operations, supporting both unit entities and spatial points.
## Use has_target() to verify target validity before accessing position or other properties.

enum TARGET_TYPE {NONE, POINT, ENTITY}
var target_type : TARGET_TYPE :
	set(value): # Prevent setting value
		return
	get:
		if self.target is UnitEntity:
			return TARGET_TYPE.ENTITY
		elif self.target is Vector3:
			return TARGET_TYPE.POINT
		else:
			return TARGET_TYPE.NONE

## The combat target, which can be either a UnitEntity or a Vector3 position.
## When set, internal tracking variables are updated based on the value type.
## This property is the main interface for setting and retrieving the current target.
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
	match self.target_type:
		TARGET_TYPE.ENTITY:
			return target.global_position
		TARGET_TYPE.POINT:
			return target
		_:
			return Vector3.INF

func has_target() -> bool:
	return self.target_type != TARGET_TYPE.NONE

func get_target_unit() -> UnitEntity:
	return _target_unit
