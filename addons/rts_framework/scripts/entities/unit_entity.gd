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
	Signals.command_issued.connect(_on_command_issued)

func move_to(target_position: Vector3) -> void:
	var move_state = state_machine.states.get("move")
	if move_state:
		print_debug(self.name, " is moving towards")
		move_state.set_target(target_position)
		state_machine.transition_to("move")

func attack(target: BaseEntity) -> void:
	var attack_state = state_machine.states.get("attack")
	if attack_state:
		print_debug(self.name, " is attacking")
		attack_state.set_target(target)
		state_machine.transition_to("attack")

func build(target_position: Vector3, scene: PackedScene) -> void:
	var build_state = state_machine.states.get("build")
	if build_state:
		print_debug(self.name, " is building")
		build_state.set_construction(scene, target_position)
		state_machine.transition_to("build")

func collect(resource: BaseEntity) -> void:
	var collect_state = state_machine.states.get("collect")
	if collect_state:
		print_debug(self.name, " is collecting")
		collect_state.set_target(resource)
		state_machine.transition_to("collect")

# --- Signal Handlers ---

func _on_units_selected(units: Array) -> void:
	if not selectable:
		return
	
	if self in units:
		selectable.select()
	else:
		selectable.deselect()

func _on_command_issued(command: String, units: Array, target: Variant, context: Dictionary) -> void:
	if self not in units:
		print_debug(self.name, " is not part of the command group.")
		return  # Ignore commands not intended for this unit
	
	match command:
		"move":
			move_to(target)
		"attack":
			attack(target)
		"build":
			if "scene" in context and "position" in context:
				build(context["position"], context["scene"])
		"collect":
			collect(target)
		_:
			print_debug("Unknown command: %s" % command)
