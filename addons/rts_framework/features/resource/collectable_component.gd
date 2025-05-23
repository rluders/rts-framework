extends BaseComponent
class_name CollectableComponent

## Emitted when resources are collected.
signal on_collected(amount: int)
## Emitted when resources run out.
signal on_depleted()

## Type of resource this component manages (gold or wood)
@export_enum("gold", "wood") var resource_type
## AAA
@export_range(0, 1000, 1, "or_greater") var resource_amount : int :
	get: 
		return _internal_amount
	set(value):
		_internal_amount = value
		if _internal_amount <= 0:
			_internal_amount = 0
			on_depleted.emit()

var _internal_amount : int = 1000

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
	var real_amount : int = amount
	if amount > self.resource_amount:
		real_amount = resource_amount
	self.resource_amount = self.resource_amount - real_amount
	on_collected.emit(real_amount)
	return real_amount

# Completely depletes the resource.
func deplete(amount: int) -> void:
	self.resource_amount = 0
