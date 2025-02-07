extends BaseEntity
class_name UnitEntity

@onready var state_machine: StateMachine = $StateMachine
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

var selectable : SelectableComponent

func _ready() -> void:
	super()
	add_to_group("units")
	
	selectable = get_component("Selectable")
	
	# Connect to global signals
	Signals.units_selected.connect(_on_units_selected)

# --- Signal Handlers ---
func _on_units_selected(units: Array) -> void:
	if not selectable:
		return
	
	if self in units:
		selectable.select()
	else:
		selectable.deselect()
