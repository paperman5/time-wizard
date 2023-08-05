class_name PositionTracker
extends Node2D

@export var top_speed := 100.0

var prev := Vector2.ZERO

func _ready():
	process_priority = 1
	prev = global_position

func _process(_delta):
	prev = global_position
