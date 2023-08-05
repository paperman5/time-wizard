class_name Level
extends Node2D

@export var time_limit : float = 65.0
@export var timer_display : TimerDisplay
@export var track : Node2D
@export var time_accel : float = 3.0

var used_time : float = 0.0
var manual_advance : bool = false : set = set_manual_advance
var time_speed = 1.0

@onready var pt = track.get_node_or_null("PositionTracker") as PositionTracker
@onready var gameover = get_node("%GameoverScreen") as Control

signal time_advance(delta : float)

func _process(delta):
	var delta_mod = delta
	if manual_advance:
		time_speed += time_accel * delta
	if is_instance_valid(pt) and not manual_advance:
		var speed = (pt.global_position - pt.prev).length() / delta
		time_speed = max(time_speed - time_accel * delta, speed / pt.top_speed)
	time_speed = clamp(time_speed, 0.0, 1.0)
	delta_mod = delta * time_speed
		
	if is_instance_valid(timer_display):
		timer_display.set_time(time_limit - used_time)
	
	if used_time >= time_limit:
		show_gameover()
	else:
		used_time += delta_mod
		time_advance.emit(delta_mod)

func set_manual_advance(value : bool):
	manual_advance = value

func show_gameover():
	timer_display.set_time(0.0)
	gameover.visible = true
