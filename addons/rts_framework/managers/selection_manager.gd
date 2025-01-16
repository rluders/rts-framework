extends Node
class_name SelectionManager

signal units_selected(units: Array)

@export var selection_box: ColorRect

var selected_units: Array = []
var start_sel_pos: Vector2 = Vector2.ZERO
var end_sel_pos: Vector2 = Vector2.ZERO
var is_dragging: bool = false

func start_selection(start_pos: Vector2) -> void:
	start_sel_pos = start_pos
	is_dragging = true
	selection_box.visible = true
	selection_box.position = start_pos
	selection_box.size = Vector2.ZERO

func update_selection(current_pos: Vector2) -> void:
	if is_dragging:
		end_sel_pos = current_pos
		var rect = Rect2(start_sel_pos, end_sel_pos - start_sel_pos).abs()
		selection_box.position = rect.position
		selection_box.size = rect.size

func end_selection(end_pos: Vector2) -> void:
	if is_dragging:
		is_dragging = false
		selection_box.visible = false
		end_sel_pos = end_pos
		var rect = Rect2(start_sel_pos, end_sel_pos - start_sel_pos).abs()
		selected_units = get_units_in_rect(rect)
		emit_signal("units_selected", selected_units)

func deselect_all() -> void:
	selected_units.clear()
	emit_signal("units_selected", [])

func get_units_in_rect(rect: Rect2) -> Array:
	var units = []
	for unit in get_tree().get_nodes_in_group("units"):
		var unit_screen_pos = Raycaster.world_to_screen(unit.global_transform.origin)
		if rect.has_point(unit_screen_pos):
			units.append(unit)
	return units
