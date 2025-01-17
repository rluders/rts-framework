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

func deselect_units() -> void:
	selected_units.clear()
	for unit in selected_units:
		var select_component = unit.get_component()
		if select_component:
			select_component.deselect()
	
	emit_signal("units_selected", [])

func select_units() -> void:
	for unit in selected_units:
		var select_component = unit.get_component()
		if select_component:
			select_component.select()
	
	emit_signal("units_selected", [])

func get_unit_under_mouse():
	return Raycaster.get_unit_under_mouse(get_parent().team) # parent is RTSController

func apply_selection() -> void:
	for unit in get_tree().get_nodes_in_group("units"):
		var selectable = unit.get_component("SelectableComponent")
		if selectable:
			selectable.deselect()
	
	for unit in selected_units:
		var selectable = unit.get_component("SelectableComponent")
		if selectable:
			selectable.select()

func get_units_in_rect(rect: Rect2) -> Array:
	var units = []
	for unit in get_tree().get_nodes_in_group("units"):
		if not unit.has_component("SelectableComponent"):
			print_debug(unit.name + " is not Selectable")
			continue
		var unit_screen_pos = Raycaster.world_to_screen(unit.global_transform.origin)
		if rect.has_point(unit_screen_pos):
			units.append(unit)
	
	return units
