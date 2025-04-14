extends Resource
class_name StateData
# States which were previously used.
# previous_states[0] is the previous array 
var previous_states : Array[String] = [] 

# Turn any class which extend StateData to StateData
# Drop all data that is not needed 
func narrow(data : StateData) -> StateData:
	var new_data : StateData = StateData.new()
	new_data.previous_states = data.previous_states
	return new_data
