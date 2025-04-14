extends Resource
class_name ProjectileData

## The projectile scene which will be instantiated
@export var projectile_scene : PackedScene

var target : AttackTarget = null

func projectile_instantiate(start_position : Vector3) -> Projectile:
	if projectile_scene == null:
		push_error("ProjectileData: projectile_scene is null")
		return null
		
	var projectile = projectile_scene.instantiate()
	if not projectile is Projectile:
		push_error("ProjectileData: instantiated scene is not a Projectile")
		projectile.queue_free()
		return null
	
	projectile.position = start_position
	projectile.target = self.target
	return projectile as Projectile

func can_instantiate() -> bool:
	return projectile_scene != null && projectile_scene.can_instantiate()
