@tool
extends BaseComponent
class_name DamageableComponent

## Emitted when damage is applied.
signal on_damage(damage: int)
## Emitted when health reaches 0.
signal on_destroyed()

## Maximum health value for this entity
@export_range(0, 100, 1, "or_greater") var max_health : int = 100
## Whether this entity can be repaired after taking damage
@export var is_repairable : bool = true

var _health : int = 0
var current_health : int :
	get:
		return _health
	set(value):
		_health = clampi(value, 0, max_health)
		if _health == 0:
			on_destroyed.emit()

func _ready() -> void:
	assert(get_owner() is BaseEntity, "Scene's owner isn't of type BaseEntity. Scene's owner name: " + get_owner().name)
	_health = max_health  # Initialize health after all properties are set

# Reduces health by the given amount.
func apply_damage(amount: int) -> int:
	if amount <= 0:
		return 0
	var real_amount = min(amount, self.current_health)
	self.current_health = self.current_health - amount
	on_damage.emit(real_amount)
	return real_amount

# Restores health up to max_health.
func repair(amount: int) -> void:
	if amount <= 0:
		return
	if is_repairable:
		self.current_health = self.current_health + amount

# Returns true if the entity's health is greater than 0.
func is_alive() -> bool:
	return current_health > 0
