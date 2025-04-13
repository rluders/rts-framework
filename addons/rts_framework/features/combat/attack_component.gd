@tool
extends BaseComponent
class_name AttackComponent

@export_range(0,1,100,"or_greater") var attack_range : int :
	set(value):
		_attack_range = value
		_attack_range_squared = value**2
	get:
		return _attack_range
# Saving both _attack_range and _attack_range_squared because calculating squre root cost a lot of performance
# Then a work around is to calculate the power of 2 and save the original value.
# The power of 2, squared, is used in func in_range
var _attack_range : int = 10
var _attack_range_squared : int = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func target_in_range(target: UnitEntity) -> bool:
	return in_range(Vector2(target.position.x, target.position.z))
	
func surface_in_range(point: Vector3) -> bool:
	return in_range(Vector2(point.x, point.z))

func in_range(targetPosition2D: Vector2) -> bool:
	var ownerPosition2D: Vector2 = Vector2(owner.position.x, owner.position.z)
	return (owner.distance_squared_to(targetPosition2D) <= _attack_range_squared)
