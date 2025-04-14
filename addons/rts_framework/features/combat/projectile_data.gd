extends Resource
class_name ProjectileData

## The projectile scene which will be instantiated
@export var projectile_scene : PackedScene

var target : AttackTarget = null

func projectile_instantiate(start_position : Vector3) -> Node3D:
	if projectile_scene == null:
		push_error("ProjectileData: projectile_scene is null")
		return null

	var projectile : Projectile = projectile_scene.instantiate() as Projectile
	projectile.position = start_position
	projectile.target = self.target
	return projectile

func projectile_can_instantiate() -> bool:
	if projectile_scene == null:
		return false
	return projectile_scene.can_instantiate()
