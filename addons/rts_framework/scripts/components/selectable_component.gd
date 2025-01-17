extends Node
class_name SelectableComponent

signal selected
signal deselected

@export var selection_sprite: Sprite3D
@export var highlight_color: Color = Color(1, 1, 0, 1)

func _ready() -> void:
	if selection_sprite:
		selection_sprite.visible = false

func select() -> void:
	if selection_sprite:
		selection_sprite.visible = true
		set_selection_color(highlight_color)
	
	emit_signal("selected")

func deselect() -> void:
	if selection_sprite:
		selection_sprite.visible = false
	
	emit_signal("deselected")

func set_selection_color(color: Color) -> void:
	if selection_sprite and selection_sprite.modulate:
		selection_sprite.modulate = highlight_color
