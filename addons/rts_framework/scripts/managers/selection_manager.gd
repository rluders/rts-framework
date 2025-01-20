extends Node
class_name SelectionManager

signal units_selected(units: Array)

@export var selection_box: ColorRect

var selected_units: Array = []
var start_sel_pos: Vector2 = Vector2.ZERO
var end_sel_pos: Vector2 = Vector2.ZERO
var is_dragging: bool = false

func _ready() -> void:
	if selection_box:
		selection_box.visible = false

func get_mouse_position() -> Vector2:
	return get_viewport().get_mouse_position()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("select"):
		start_selection(get_mouse_position())
	elif Input.is_action_just_released("select"):
		end_selection(get_mouse_position())
	
	if is_dragging:
		update_selection_box(get_viewport().get_mouse_position())

func start_selection(start_pos: Vector2) -> void:
	start_sel_pos = start_pos
	is_dragging = true
	
	selection_box.visible = true
	selection_box.position = start_pos
	selection_box.size = Vector2.ZERO

func end_selection(end_pos: Vector2) -> void:
	if is_dragging:
		is_dragging = false
		selection_box.visible = false
		end_sel_pos = end_pos
		
		if start_sel_pos.distance_squared_to(end_sel_pos) < 16:
			selected_units = get_clicked_unit()
		else:
			var rect = Rect2(start_sel_pos, end_sel_pos - start_sel_pos).abs()
			selected_units = get_units_in_rect(rect)
		
		apply_selection()
		
		emit_signal("units_selected", selected_units)

func update_selection_box(current_pos: Vector2) -> void:
	if is_dragging:
		end_sel_pos = current_pos

		var rect = Rect2(start_sel_pos, end_sel_pos - start_sel_pos).abs()
		selection_box.position = rect.position
		selection_box.size = rect.size

func get_selected_units() -> Array:
	return selected_units

func has_selected_units() -> bool:
	return len(selected_units) > 0

func apply_selection() -> void:
	for unit in get_tree().get_nodes_in_group("units"):
		var selectable = unit.get_component("Selectable")
		if selectable:
			selectable.deselect()
	
	for unit in selected_units:
		var selectable = unit.get_component("Selectable")
		if selectable:
			selectable.select()

func get_clicked_unit() -> Array:
	var clicked_unit = get_unit_under_mouse(get_parent().team) # parent is RTSController
	if not clicked_unit:
		return []
	return [clicked_unit]

func get_units_in_rect(rect: Rect2) -> Array:
	var units = []
	for unit in get_tree().get_nodes_in_group("units"):
		if not unit.has_component("Selectable"):
			continue
		if "team" not in unit or unit.team != get_parent().team:
			continue
		var unit_screen_pos = Raycaster.world_to_screen(unit.global_transform.origin)
		if rect.has_point(unit_screen_pos):
			units.append(unit)
	
	return units

func get_unit_under_mouse(team: int):
	var result = Raycaster.perform_raycast(3) # Layer for units
	if result.collider:
		var unit = result.collider.get_parent()
		if "team" in unit and unit.team == team and unit.is_in_group("units"):
			return unit
	return null
