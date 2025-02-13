extends BaseEntity
class_name UnitEntity

@onready var state_machine: StateMachine = $StateMachine
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

var selectable : SelectableComponent

func _ready() -> void:
	super()
	add_to_group("units")
