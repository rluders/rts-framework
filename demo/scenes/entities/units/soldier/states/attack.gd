extends State

func enter() -> void:
	print_debug("Enter: ", self.name)

func exit() -> void:
	print_debug("Exit: ", self.name)
	
func set_target(target_position: BaseEntity):
	pass
