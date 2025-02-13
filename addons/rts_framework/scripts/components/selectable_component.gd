extends Node
class_name SelectableComponent

signal selected
signal deselected

@export var root_entity : BaseEntity
@export var selection_sprite: Sprite3D
@export var highlight_color: Color = Color(1, 1, 0, 1)

func _ready() -> void:
	assert(root_entity != null, "root_entity must be set for SelectableComponent")
	
	if selection_sprite:
		selection_sprite.visible = false
	
	# Connect to global signals
	Signals.units_selected.connect(_on_units_selected)

func select() -> void:
	if selection_sprite:
		selection_sprite.visible = true
		set_selection_color(highlight_color)
	
	selected.emit()

func deselect() -> void:
	if selection_sprite:
		selection_sprite.visible = false
	
	deselected.emit()

func set_selection_color(color: Color) -> void:
	if selection_sprite and selection_sprite.modulate:
		selection_sprite.modulate = highlight_color

# --- Signal Handlers ---
func _on_units_selected(units: Array) -> void:
	if root_entity in units:
		select()
	else:
		deselect()
