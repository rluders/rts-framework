extends State

@export var navigation_agent: NavigationAgent3D

@export var speed : float = 20
@export var acceleration : float = 10

var target_position: Vector3
var body
var word_pos

func _ready() -> void:
	body = get_root_node()
	
	navigation_agent.velocity_computed.connect(func (v): set_linear_velocity(v))
	navigation_agent.target_reached.connect(_on_target_reached)

func set_linear_velocity(velocity) -> void:
	body.velocity = velocity

func enter(params: Dictionary = {}) -> void:
	if params.has("target_position"):
		target_position = params["target_position"]
		
		var navmap = body.get_world_3d().get_navigation_map()
		var closest_point = NavigationServer3D.map_get_closest_point(navmap, target_position)
		navigation_agent.target_position = closest_point
		
		print_debug("Entering %s State to position: " % self.name, closest_point)

func exit() -> void:
	print_debug("Exiting %s State" % self.name)

func physics_update(delta: float) -> void:
	if target_position:
		var direction : Vector3
		
		direction = navigation_agent.get_next_path_position() - body.global_position
		direction = direction.normalized()
		
		body.velocity = body.velocity.lerp(direction * speed, acceleration * delta)
		body.move_and_slide()

func update(delta: float) -> void:
	pass

func _on_target_reached() -> void:
	state_transitioned.emit(self, "idle")
