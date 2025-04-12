extends Node
class_name BaseComponent

func _get_configuration_warnings() -> PackedStringArray:
	var warnings : PackedStringArray = PackedStringArray([])
	if owner is not BaseEntity:
		warnings.append("Component's Owner is not BaseEntity")
	return warnings
