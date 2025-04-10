extends BaseComponent
class_name DamageableComponent

## Emitted when damage is applied.
signal on_damage(damage: int)
## Emitted when health reaches 0.
signal on_destroyed()

## AAA
@export_range(0, 100, 1, "or_greater") var max_health : int = 100
## AAA
@export var is_repairable : bool = true

var current_health : int = self.max_health :
	set(value):
		self.current_health = clampi(value, 0, self.max_health)
		if self.current_health == 0:
			emit_signal("on_destroyed")
	

func _ready() -> void:
	assert(get_owner() is BaseEntity, "Scene's owner isn't of type BaseEntity. Scene's owner name: " + get_owner().name)

# Reduces health by the given amount.
func apply_damage(amount: int) -> void:
	self.current_health = self.current_health - amount
	emit_signal("on_damage", amount)

# Restores health up to max_health.
func repair(amount: int) -> void:
	if is_repairable:
		self.current_health = self.current_health + amount

# Returns true if the entity's health is greater than 0.
func is_alive() -> bool:
	return (current_health > 0)
