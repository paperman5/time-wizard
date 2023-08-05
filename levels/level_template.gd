class_name Level
extends Node2D

@export var time_limit : float = 65.0
@export var timer_display : TimerDisplay
@export var track : Node2D
@export var time_accel : float = 3.0

var used_time : float = 0.0
var manual_advance : bool = false : set = set_manual_advance
var time_speed = 0.0
var level_load_buffer : float = 0.5
var time_paused := true

@onready var pt = track.get_node_or_null("PositionTracker") as PositionTracker
@onready var gameover = get_node("%GameoverScreen") as Control

signal time_advance(delta : float)

func _ready():
	get_tree().create_timer(level_load_buffer).timeout.connect(resume_time)

func _process(delta):
	if not time_paused:
		var delta_mod = delta
		if manual_advance:
			time_speed += time_accel * delta
		if is_instance_valid(pt) and not manual_advance:
			var speed = (pt.global_position - pt.prev).length() / delta
			time_speed = max(time_speed - time_accel * delta, speed / pt.top_speed)
		time_speed = clamp(time_speed, 0.0, 1.0)
		delta_mod = delta * time_speed
		
		if used_time >= time_limit:
			show_gameover()
		else:
			used_time += delta_mod
			time_advance.emit(delta_mod)
	
	if is_instance_valid(timer_display):
			timer_display.set_time(time_limit - used_time)

func set_manual_advance(value : bool):
	manual_advance = value

func show_gameover():
	timer_display.set_time(0.0)
	gameover.visible = true

func pause_time():
	time_paused = true

func resume_time():
	time_paused = false

func _on_retry_pressed():
	pass

func _on_quit_pressed():
	pass

func _unhandled_input(event):
	if event.is_action_pressed("test_button"):
		pause_time() if not time_paused else resume_time()
