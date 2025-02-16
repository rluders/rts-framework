extends Node
class_name SelectableComponent

signal selected
signal deselected

@export var root_entity : BaseEntity
@export var selection_sprite: Sprite3D
@export var highlight_color: Color = Color(1, 1, 0, 1)

var is_selected : bool = false

func _ready() -> void:
	assert(root_entity != null, "root_entity must be set for SelectableComponent")
	
	if selection_sprite:
		selection_sprite.visible = false

func select() -> void:
	if selection_sprite:
		selection_sprite.visible = true
		set_selection_color(highlight_color)
	
	is_selected = true
	
	selected.emit()

func deselect() -> void:
	if selection_sprite:
		selection_sprite.visible = false
	
	is_selected = false
	
	deselected.emit()

func toggle_selection() -> void:
	if is_selected:
		deselect()
	else:
		select()

func set_selection_color(color: Color) -> void:
	if selection_sprite and selection_sprite.modulate:
		selection_sprite.modulate = highlight_color
