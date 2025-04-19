extends WeakRef
class_name UnitVisionDataWeakRef

# fow_circle
var fow_circle_radius : float :
	get:
		return get_ref().fow_circle.radius
	set(value):
		get_ref().fow_circle.radius = value

var fow_circle_color : Color :
	get:
		return get_ref().fow_circle.color
	set(value):
		get_ref().fow_circle.color = value

# shroud_circle
var shroud_circle_radius : float :
	get:
		return get_ref().shroud_circle.radius
	set(value):
		get_ref().shroud_circle.radius = value

var shroud_circle_color : Color :
	get:
		return get_ref().shroud_circle.color
	set(value):
		get_ref().shroud_circle.color = value

# shape_3d
var sight_range : float :
	get:
		return get_ref().shape_3d.shape.radius
	set(value):
		get_ref().shape_3d.shape.radius = value

static func create(unit_vision_data : UnitVisionData) -> UnitVisionDataWeakRef:
	return weakref(unit_vision_data)
