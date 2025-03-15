# DynamicCircle2D

description placeholder

## **Class**

- **Base node/class**: `Node2D`

## **Properties**

- color
	- type  Color
    - default value Color.WHITE
- radius
    - type int
    - default value 15

## **Events**

- None

## **Dependencies**
- None

## Code
```gdscript
@tool
extends Node2D

@export var color : Color = Color.WHITE:
	set(value):
		color = value
		queue_redraw()

@export var radius : int = 15:
	set(value):
		radius = value
		queue_redraw()

func _draw():
	draw_circle(Vector2(0, 0), radius, color)
```
