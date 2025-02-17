extends State

func enter(params: Dictionary = {}) -> void:
	print("Entering Idle State")

func exit() -> void:
	print("Exiting Idle State")

func update(delta: float) -> void:
	pass
