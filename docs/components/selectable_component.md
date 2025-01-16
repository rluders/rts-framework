# SelectableComponent

The `SelectableComponent` adds selection functionality to entities, allowing them to be highlighted when selected and deselected when no longer part of the player’s active selection. This component uses a `Sprite3D` node for visual feedback and integrates with systems like `SelectionManager`.

## **Class**

- **Base node/class**: `Node`
- **Class name**: `SelectableComponent`

## **Methods**

- `select() -> void`: Highlights the entity, marking it as selected.
- `deselect() -> void`: Removes the selection highlight from the entity.
- `set_selection_color(color: Color) -> void`: Updates the selection highlight to use a specific color.

## **Properties**

- `@export var selection_sprite: Sprite3D`: A reference to the `Sprite3D` used to visually indicate selection.
- `@export var highlight_color: Color = Color(1, 1, 0, 1)`: The color used to highlight the entity when selected.

## **Events**

- `selected`: Emitted when the entity is selected.
- `deselected`: Emitted when the entity is deselected.

## **Dependencies**

- **Sprite3D**: Used to visually represent the selection highlight.

## Code

```gdscript
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
    if selection_sprite and selection_sprite.material_override:
        var material = selection_sprite.material_override as ShaderMaterial
        if material:
            material.set_shader_param("selection_color", color)
```