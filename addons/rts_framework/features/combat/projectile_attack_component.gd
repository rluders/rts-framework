@tool
extends AttackComponent
class_name ProjectileAttackComponent

signal generated_projectile(projectile : ProjectileData)

## todo
@export var projectile : ProjectileData

func generate_projectile(target) -> bool:
	if projectile.projectile_can_instantiate():
		var proj = projectile.projectile_instantiate(owner.position)
		generated_projectile.emit(projectile)
		return true
	return false

func _get_configuration_warnings() -> PackedStringArray:
	var warnings : PackedStringArray = super()
	if projectile == null:
		warnings.append("Missing Projectile")
	return warnings
