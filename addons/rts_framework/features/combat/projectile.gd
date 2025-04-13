@icon("res://addons/rts_framework/features/combat/projectile_icon.svg")
extends MeshInstance3D
class_name Projectile

var speed : float = 0.0 #TODO : Change to Vector3. This can be something that slings, that goes up and then down. Not necessarily straight arrow
#var start_y_direction # Maybe an idea how to do the sling shots  
var lifetime : float :
	set(value):
		$Timer.wait_time = value
	get:
		return $Timer.wait_time
var collision_damage : int = 10
var target : AttackTarget = null

func _physics_process(delta: float) -> void:
	if target.has_target():
		#TODO : Change to support slinging shots
		var direction = (target.get_target_position() - global_position).normalized()
		global_position += direction * speed * delta
		look_at(target.get_target_position(), Vector3.UP)

func _collide() -> void:
	# Apply damage to the target if it's a unit
	if target.get_target_unit() != null:
		if target.get_target_unit().has_component("damageable_comonent") :
			target.get_target_unit().get_component("damageable_component").apply_damage(collision_damage) # Replace with actual damage value
	self.queue_free()

func _timedout() -> void:
	self.queue_free()
