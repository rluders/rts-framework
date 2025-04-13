@icon("res://addons/rts_framework/features/combat/projectile_icon.svg")
extends MeshInstance3D
class_name Projectile

var speed : float = 0.0 #TODO : Change to Vector3. This can be something that slings, that goes up and then down. Not necessarily straight arrow
var lifetime : float :
	set(value):
		$Timer.wait_time = value
	get:
		return $Timer.wait_time
var collision_damage : int = 10

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


func _init() -> void:
	pass
	
func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	var target_position : Vector3
	if _target_unit != null:
		target_position = _target_unit.global_position
	elif _target_point != Vector3.INF:
		target_position = _target_point
	
	var direction = (target_position - global_position).normalized()
	global_position += direction * speed * delta
	look_at(target_position, Vector3.UP)

func _collide() -> void:
	# Apply damage to the target if it's a unit
	if _target_unit != null:
		if _target_unit.has_component("damageable_component") :
			_target_unit.get_component("damageable_component").apply_damage(collision_damage) # Replace with actual damage value
	self.queue_free()

func _timedout() -> void:
	self.queue_free()
