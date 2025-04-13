@tool
extends AttackComponent
class_name MeleeAttackComponent

## Emitted when applying damage.
signal applyed_damage(damage: int)

func apply_damage(target: UnitEntity, damage: int) -> int:
	if self.target_in_range(target):
		if target.has_component("damageable_component"):
			var damaComponent : DamageableComponent = target.get_component("damageable_component")
			var real_damage : int = damaComponent.apply_damage(damage)
			applyed_damage.emit(real_damage)
			return real_damage
	return 0
