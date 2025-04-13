@tool
extends AttackComponent
class_name ProjectileAttackComponent

signal generated_projectile(projectile : ProjectileData)

## The projectile data resource that defines the projectile's properties and behavior
@export var projectile : ProjectileData

func generate_projectile(target) -> bool:
	if target == null or owner == null or projectile == null:
		return false
	if projectile.projectile_can_instantiate():
		var proj = projectile.projectile_instantiate(owner.position)
		proj.target = target
		generated_projectile.emit(projectile)
		return true
	return false

func _get_configuration_warnings() -> PackedStringArray:
	var warnings : PackedStringArray = super()
	if projectile == null:
		warnings.append("Missing Projectile")
	return warnings
