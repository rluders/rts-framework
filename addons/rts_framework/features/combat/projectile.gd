@icon("res://addons/rts_framework/features/combat/projectile_icon.svg")
extends MeshInstance3D
class_name Projectile

var speed : int = 0 #TODO : Change to Vector3. This can be something that slings, that goes up and then down. Not nesserally stright arrow
var lifetime : float :
	set(value):
		$Timer.wait_time = value
	get:
		return $Timer.wait_time

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


func _init() -> void:
	pass
	
func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	#TODO : Make it move forward the target
	#TODO : Make it spin forward the target
	pass

func _collide() -> void:
	self.queue_free()

func _timedout() -> void:
	self.queue_free()
