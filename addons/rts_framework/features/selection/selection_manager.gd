extends BaseManager
class_name SelectionManager

const CLICK_DISTANCE_THRESHOLD : float = 16.0

@export var selection_box: ColorRect
@export var team: int = 0:
	set(value):
		if value < 0:
			push_error("Team ID cannot be negative")
			return
		team = value

var selected_units: Array = []
var old_selected_units: Array = []

var is_dragging: bool = false
var start_sel_pos: Vector2 = Vector2.ZERO
var end_sel_pos: Vector2 = Vector2.ZERO

# TODO: Consider using a shared `AttackTarget` resource managed by `selection_manager`.
# When units are selected, pass a shared target to them so that all generated projectiles reference
# the same AttackTarget. This approach will help avoid collisions in state management if multiple projectiles
# would otherwise reference distinct target instances.

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("select"):
		_start_selection(_get_mouse_position())
	elif Input.is_action_just_released("select"):
		_end_selection(_get_mouse_position())
	
	if is_dragging:
		_update_selection_box(_get_mouse_position())

func _start_selection(start_pos: Vector2) -> void:
	is_dragging = true
	start_sel_pos = start_pos
	selection_box.visible = true
	selection_box.position = start_pos
	selection_box.size = Vector2.ZERO

func _end_selection(end_pos: Vector2) -> void:
	is_dragging = false
	selection_box.visible = false
	end_sel_pos = end_pos
	
	old_selected_units = selected_units
	
	if start_sel_pos.distance_squared_to(end_pos) < CLICK_DISTANCE_THRESHOLD:
		selected_units = _get_clicked_unit()
	else:
		selected_units = _get_units_in_rect(Rect2(start_sel_pos, end_sel_pos - start_sel_pos).abs())
	
	_update_selected_group()
	_apply_selection()

func _apply_selection() -> void:
	var team_group_name = get_team_group_name()
	
	for unit in old_selected_units:
		unit.remove_from_group(team_group_name)
		unit.get_component("Selectable").deselect()
	
	for unit in selected_units:
		unit.add_to_group(team_group_name)
		unit.get_component("Selectable").select()

func _update_selection_box(current_pos: Vector2) -> void:
	if is_dragging:
		end_sel_pos = current_pos
		var rect = Rect2(start_sel_pos, end_sel_pos - start_sel_pos).abs()
		selection_box.position = rect.position
		selection_box.size = rect.size

func _update_selected_group() -> void:
	var group_name = get_team_group_name()
	for unit in get_tree().get_nodes_in_group(group_name):
		unit.remove_from_group(group_name)

	for unit in selected_units:
		# It will only select units that has the selectable component
		if unit.has_component("Selectable"):
			unit.add_to_group(group_name)

func _get_mouse_position() -> Vector2:
	return get_viewport().get_mouse_position()

func _get_clicked_unit() -> Array:
	var result = Raycaster.perform_raycast(3)  # Layer mask for units
	if result and result.collider:
		var unit = result.collider
		if unit and "team" in unit and unit.team == team and unit.is_in_group("units"):
			return [unit]
	return []

func _get_units_in_rect(rect: Rect2) -> Array:
	var units = []
	for unit in get_tree().get_nodes_in_group("units"):
		if unit.team != team:
			continue
		var screen_pos = Raycaster.world_to_screen(unit.global_transform.origin)
		if rect.has_point(screen_pos):
			units.append(unit)
	return units

func get_team_group_name() -> String:
	return "team_%d_selected" % team
