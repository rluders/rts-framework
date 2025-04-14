extends State

func enter(data: StateData = null) -> void:
	print("Entering Idle State")
	super(data)

func exit(data: StateData = null) -> void:
	print("Exiting Idle State")
	super(data)

func update(delta: float) -> void:
	pass
