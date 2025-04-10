extends BaseComponent
class_name CollectableComponent

## Emitted when resources are collected.
signal on_collected(amount: int)
## Emitted when resources run out.
signal on_depleted()

## Type of resource this component manages (gold or wood)
@export_enum("gold", "wood") var resource_type
## AAA
@export_range(0, 1000, 1, "or_greater") var resource_amount : int = 1000 :
	set(value):
		resource_amount = value
		if resource_amount <= 0:
			resource_amount = 0
			emit_signal("on_depleted")
## Whether the resource has been completely depleted (read-only)
var  is_depleted : bool : 
	set(value):
		return # Can't set
	get:
		return (resource_amount <= 0)
	

func _ready() -> void:
	assert(get_owner() is BaseEntity, "Scene's owner isn't of type BaseEntity. Scene's owner name: " + get_owner().name)

# Reduces resource amount and returns the actual collected amount.
func collect(amount: int) -> int:
	if amount <= 0:
		return 0
	if amount > self.resource_amount:
		var real_amount = resource_amount
		self.resource_amount = 0
		return real_amount
	self.resource_amount = self.resource_amount - amount
	return amount

# Completely depletes the resource.
func deplete(amount: int) -> void:
	self.resource_amount = 0
