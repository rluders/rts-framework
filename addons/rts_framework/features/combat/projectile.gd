@icon("res://addons/rts_framework/features/combat/projectile_icon.svg")
extends MeshInstance3D
class_name Projectile

signal collided(target : AttackTarget)
signal timeout

var speed : float = 0.0
# If doing artilirey, or alike, then can use tween or another calculation to do the trajectory
# Default flat trajectory
var calculate_y_direction: Callable = func(_delta: float, _current_position: Vector3, _target_position: Vector3) -> float : return 0.0
var lifetime : float :
	set(value):
		$Timer.wait_time = value
	get:
		return $Timer.wait_time
var collision_damage : int = 10
var target : AttackTarget = null

func _physics_process(delta: float) -> void:
	if target.has_target():
		var direction = (target.get_target_position() - global_position).normalized()
		direction.y = calculate_y_direction.call(delta, global_position, target.get_target_position())
		global_position += direction * speed * delta
		look_at(target.get_target_position(), Vector3.UP)

func _collide() -> void:
	# Apply damage to the target if it's a unit
	if target.get_target_unit() != null:
		if target.get_target_unit().has_component("damageable_comonent") :
			target.get_target_unit().get_component("damageable_component").apply_damage(collision_damage) # Replace with actual damage value
	collided.emit(target)
	self.queue_free()

func _timedout() -> void:
	timeout.emit()
	self.queue_free()
