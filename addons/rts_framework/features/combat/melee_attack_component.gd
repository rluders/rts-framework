@tool
extends AttackComponent
class_name MeleeAttackComponent

## Emitted when applying damage.
signal applied_damage(damage: int)

func apply_damage(target: UnitEntity, damage: int) -> int:
	if target == null:
		return 0
	if self.target_in_range(target):
		if target.has_component("damageable_component"):
			var damageComponent : DamageableComponent = target.get_component("damageable_component")
			var real_damage : int = damageComponent.apply_damage(damage)
			applied_damage.emit(real_damage)
			return real_damage
	return 0
