extends BaseEntity
class_name UnitEntity

signal movement_finished
signal passive_movement_started
signal passive_movement_finished

@export_group("Navigation")

## Initial random dispersion factor to prevent units from stacking at spawn
@export_range(0, 1, 0.1, "or_greater") var INITIAL_DISPERSION_FACTOR : float = 0.1

## Whether to track and emit signals for passive movement (movement not directed by navigation)
@export var  PASSIVE_MOVEMENT_TRACKING_ENABLED : bool = true

@export_subgroup("Stuck Prevention", "STUCK_PREVENTION")
## Whether to enable the stuck prevention system to help units navigate around obstacles
@export var  STUCK_PREVENTION_ENABLED : bool = true
## number of frames for accumulating distance traveled
@export_range(0, 100, 1, "or_greater") var  STUCK_PREVENTION_WINDOW_SIZE : int = 10
## fraction of expected distance traveled at full speed
@export_range(0, 1, 0.1, "or_greater") var  STUCK_PREVENTION_THRESHOLD : float = 0.3
## number of forced moves to the side if stuck
@export_range(0, 100, 1, "or_greater") var  STUCK_PREVENTION_SIDE_MOVES : int = 15

@export_subgroup("Rotation Low Pass Filter", "ROTATION_LOW_PASS_FILTER")
## TODO: Add description
@export var  ROTATION_LOW_PASS_FILTER_ENABLED : bool = true
## number of frames for accumulating directions
@export_range(0, 100, 1, "or_greater") var  ROTATION_LOW_PASS_FILTER_WINDOW_SIZE : int = 10
## velocities below will be dropped  
@export_range(0, 1, 0.01, "or_greater") var  ROTATION_LOW_PASS_FILTER_VELOCITY_THRESHOLD : float = 0.01  

## Unit movement speed
@export var speed : float = 0.0

var _interim_speed: float = 0.0

var _stuck_prevention_window : Array[float] = []
var _total_velocity_in_stuck_prevention_window : float = 0.0
var _number_of_forced_side_moves_left : int = 0

var _rotation_low_pass_filter_window : Array[Vector3] = []
var _total_direction_in_the_low_pass_filter_window : Vector3 = Vector3.ZERO
var _previously_set_global_transform_of_unit = null

var _passive_movement_detected : bool = false

@onready var state_machine: StateMachine = $StateMachine
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

var selectable : SelectableComponent

func _ready() -> void:
	super()
	add_to_group("units")
	
	navigation_agent.velocity_computed.connect(_on_velocity_computed)
	navigation_agent.navigation_finished.connect(_on_navigation_finished)
	_align_unit_position_to_navigation()
	move(
		(
			self.global_position
			+ Vector3(randf(), 0, randf()).normalized() * INITIAL_DISPERSION_FACTOR
		)
	)

func _physics_process(delta) -> void:
	_interim_speed = speed * delta
	var fake_direction = _get_fake_direction_due_to_stuck_prevention()
	if fake_direction != Vector3.ZERO:
		navigation_agent.set_velocity(fake_direction * _interim_speed)
		return
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	var current_agent_position: Vector3 = self.global_transform.origin
	var new_velocity: Vector3 = (
		(next_path_position - current_agent_position).normalized() * _interim_speed
	)
	navigation_agent.set_velocity(new_velocity)

func move(movement_target: Vector3) -> void:
	navigation_agent.target_position = movement_target


func stop() -> void:
	navigation_agent.target_position = Vector3.INF


func _align_unit_position_to_navigation() -> void:
	await get_tree().process_frame  # wait for navigation to be operational
	self.global_transform.origin = (
		NavigationServer3D.map_get_closest_point(
			navigation_agent.get_navigation_map(), self.global_transform.origin
		)
		- Vector3(0, navigation_agent.path_height_offset, 0)
	)


func _is_moving_actively() -> bool:
	return navigation_agent.get_next_path_position() != self.global_position

# Return the further direction from the path, to try and mmove to unstuck
# If stuck, validated by _number_of_forced_side_moves_left > 0
func _get_fake_direction_due_to_stuck_prevention() -> Vector3:
	if (
		not STUCK_PREVENTION_ENABLED
		or not _is_moving_actively()
		or _number_of_forced_side_moves_left == 0
	):
		return Vector3.ZERO
	_number_of_forced_side_moves_left -= 1
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	var direction_to_target = (next_path_position - self.global_position).normalized()
	var current_navigation_path = navigation_agent.get_current_navigation_path()
	var current_navigation_path_index = navigation_agent.get_current_navigation_path_index()
	if current_navigation_path.size() <= 1 or current_navigation_path_index == 0:
		return direction_to_target.rotated(Vector3.UP, PI / 2.0) # rotate +90* (left)
	# rotate +90*/-90* and choose the one that goes further from path
	# +90*/-90* is left/right
	var option_a = direction_to_target.rotated(Vector3.UP, PI / 2.0)
	var option_b = direction_to_target.rotated(Vector3.UP, -PI / 2.0)
	var previous_path_position = current_navigation_path[current_navigation_path_index - 1]
	if (
		(self.global_position + option_a).distance_to(previous_path_position)
		> (self.global_position + option_b).distance_to(previous_path_position)
	):
		return option_a
	return option_b


# Updates stuck prevention variables.
# If did STUCK_PREVENTION_WINDOW_SIZE movements and moved less than stuck_prevention_threshold
# Then set _number_of_forced_side_moves_left to STUCK_PREVENTION_SIDE_MOVES
func _update_stuck_prevention(safe_velocity: Vector3) -> void:
	if not _is_moving_actively():
		return
	_stuck_prevention_window.append(safe_velocity.length())
	_total_velocity_in_stuck_prevention_window += safe_velocity.length()
	if _stuck_prevention_window.size() > STUCK_PREVENTION_WINDOW_SIZE:
		_total_velocity_in_stuck_prevention_window -= _stuck_prevention_window.pop_front()
	var stuck_prevention_threshold = (
		_interim_speed * STUCK_PREVENTION_WINDOW_SIZE * STUCK_PREVENTION_THRESHOLD
	)
	if (
		_stuck_prevention_window.size() == STUCK_PREVENTION_WINDOW_SIZE
		and _total_velocity_in_stuck_prevention_window < stuck_prevention_threshold
	):
		_number_of_forced_side_moves_left = STUCK_PREVENTION_SIDE_MOVES


func _get_filtered_rotation_direction(safe_velocity: Vector3) -> Vector3:
	var direction = safe_velocity.normalized()
	if (
		_previously_set_global_transform_of_unit != null # start moving
		and not _previously_set_global_transform_of_unit.is_equal_approx(self.global_transform)
	):
		# reset filter if a global_transform of unit was altered from the outside
		_rotation_low_pass_filter_window = []
		_total_direction_in_the_low_pass_filter_window = Vector3.ZERO
	if safe_velocity.length() >= ROTATION_LOW_PASS_FILTER_VELOCITY_THRESHOLD:
		_rotation_low_pass_filter_window.append(direction)
		_total_direction_in_the_low_pass_filter_window += direction
	if _rotation_low_pass_filter_window.size() > ROTATION_LOW_PASS_FILTER_WINDOW_SIZE:
		_total_direction_in_the_low_pass_filter_window -= (
			_rotation_low_pass_filter_window.pop_front()
		)
	if _rotation_low_pass_filter_window.size() == ROTATION_LOW_PASS_FILTER_WINDOW_SIZE:
		return ( # Return average direction
			_total_direction_in_the_low_pass_filter_window
			/ float(ROTATION_LOW_PASS_FILTER_WINDOW_SIZE)
		)
	return direction


func _rotate_in_direction(direction: Vector3) -> void:
	if ROTATION_LOW_PASS_FILTER_ENABLED:
		direction = _get_filtered_rotation_direction(direction)
	var rotation_target = self.global_transform.origin + direction
	if (
		not is_zero_approx(direction.length())
		and not rotation_target.is_equal_approx(self.global_transform.origin)
	):
		self.global_transform = self.global_transform.looking_at(rotation_target)


func _update_passive_movement_tracking(safe_velocity) -> void:
	if not PASSIVE_MOVEMENT_TRACKING_ENABLED:
		return
	if _is_moving_actively() or safe_velocity.is_zero_approx():
		if _passive_movement_detected:
			_passive_movement_detected = false
			passive_movement_finished.emit()
		return
	if not _passive_movement_detected:
		_passive_movement_detected = true
		passive_movement_started.emit()


func _on_velocity_computed(safe_velocity: Vector3) -> void:
	_update_stuck_prevention(safe_velocity)
	
	# Rotate to the moving direction
	_rotate_in_direction(safe_velocity * Vector3(1, 0, 1))
	
	_update_unit_position_on_velocity_computed(safe_velocity)
	
	_previously_set_global_transform_of_unit = self.global_transform
	_update_passive_movement_tracking(safe_velocity)

# Overwrite, if needed
func _update_unit_position_on_velocity_computed(safe_velocity: Vector3) -> void:
	# Move the unit forward
	# Swap this, if not using a CharacterBody3D or RigidBody3D
	self.global_transform.origin = self.global_transform.origin.move_toward(
		self.global_transform.origin + safe_velocity, _interim_speed
	)

func _on_navigation_finished() -> void:
	navigation_agent.target_position = Vector3.INF
	movement_finished.emit()
