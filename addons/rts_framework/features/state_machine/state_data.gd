extends Resource
class_name StateData
## States which were previously used.
## Previous states[0] contains the name of the immediate previous state
@export var previous_states : Array[String] = [] 

func _init() -> void:
	pass

# Turn any class which extend StateData to StateData
# Drop all data that is not needed 
static func narrow(data : StateData) -> StateData:
	if data == null:
		push_error("Cannot narrow null StateData")
		return StateData.new()
	var new_data : StateData = StateData.new()
	new_data.previous_states = data.previous_states
	return new_data
