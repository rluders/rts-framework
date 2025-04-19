extends Resource
class_name UnitVisionData

const EMPTY_RADUIS : float = -1
const EMPTY_COLOR : Color = Color.TRANSPARENT
const EMPTY_VECTOR3 : Vector3 = Vector3.INF
const EMPTY_VECTOR2 : Vector2 = Vector2.INF

var unit : BaseEntity = null
var fow_circle : Node2D = null
var shroud_circle : Node2D = null
var minimap_circle : Node2D = null
var shape_3d : CollisionShape3D = null


# fow_circle
var fow_circle_radius : float :
	get:
		if fow_circle == null:
			return EMPTY_RADUIS
		return fow_circle.radius
	set(value):
		if fow_circle == null:
			return
		fow_circle.radius = value
		emit_changed()

var fow_circle_color : Color :
	get:
		if fow_circle == null:
			return EMPTY_COLOR
		return fow_circle.color
	set(value):
		if fow_circle == null:
			return
		fow_circle.color = value
		emit_changed()

# shroud_circle
var shroud_circle_radius : float :
	get:
		if shroud_circle == null:
			return EMPTY_RADUIS
		return shroud_circle.radius
	set(value):
		if shroud_circle == null:
			return
		shroud_circle.radius = value
		emit_changed()

var shroud_circle_color : Color :
	get:
		if shroud_circle == null:
			return EMPTY_COLOR
		return shroud_circle.color
	set(value):
		if shroud_circle == null:
			return
		shroud_circle.color = value
		emit_changed()

# minimap_circle
var minimap_circle_radius : float :
	get:
		if minimap_circle == null:
			return EMPTY_RADUIS
		return minimap_circle.radius
	set(value):
		if minimap_circle == null:
			return
		minimap_circle.radius = value
		emit_changed()

var minimap_circle_color : Color :
	get:
		if minimap_circle == null:
			return EMPTY_COLOR
		return minimap_circle.color
	set(value):
		if minimap_circle == null:
			return
		minimap_circle.color = value
		emit_changed()

# shape_3d
var sight_range : float :
	get:
		if shape_3d == null || shape_3d.shape == null:
			return EMPTY_RADUIS
		return shape_3d.shape.radius
	set(value):
		if shape_3d == null || shape_3d.shape == null:
			return
		shape_3d.shape.radius = value
		emit_changed()

# All
var position : Vector3 :
	get:
		if shape_3d == null:
			return EMPTY_VECTOR3
		return shape_3d.position
	set(value): # Prevent setting
		return

static func create(unit, fow_circle, shroud_circle, shape_3d, minimap_circle = null) -> UnitVisionData:
	var instance = UnitVisionData.new()
	instance.unit = unit
	instance.fow_circle = fow_circle
	instance.shroud_circle = shroud_circle
	instance.shape_3d = shape_3d
	if minimap_circle != null:
		instance.minimap_circle = minimap_circle
	return instance

# TODO: Talk about having a RefCounted in the unit itself and
# in vision manager have weakref.
# That way, when unit is freed, it will automateclly free this resource 
func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		if fow_circle:
			fow_circle.queue_free()
		if shroud_circle:
			shroud_circle.queue_free()
		if minimap_circle:
			minimap_circle.queue_free()
		if shape_3d:
			shape_3d.queue_free()

func sync_position(texture_units_per_world_unit : int) -> void:
	var unit_pos_3d = unit.global_transform.origin
	var unit_pos_2d = Vector2(unit_pos_3d.x, unit_pos_3d.z) * texture_units_per_world_unit
	
	# Check if any component exists to determine if we need to emit a change
	var should_emit = fow_circle != null || shroud_circle != null || minimap_circle != null || shape_3d != null

	if fow_circle:
		fow_circle.position = unit_pos_2d
	if shroud_circle:
		shroud_circle.position = unit_pos_2d
	if minimap_circle:
		minimap_circle.position = unit_pos_2d
	if shape_3d:
		shape_3d.position = unit_pos_3d
	if should_emit:
		emit_changed()
