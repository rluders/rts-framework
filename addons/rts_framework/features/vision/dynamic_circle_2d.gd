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
