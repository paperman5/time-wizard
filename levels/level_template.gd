class_name Level
extends Node2D

@export var time_limit : float = 65.0
@export var timer_display : TimerDisplay
@export var track : Node2D
@export var next_level : PackedScene

var time_accel : float = 3.0
var used_time : float = 0.0
var manual_advance : bool = false : set = set_manual_advance
var time_speed = 0.0
var level_load_buffer : float = 0.5
var time_paused := true
var n_organ_parts : int = 0
var parts_collected : int = 0
var time_add_marker = preload("res://components/time_add_marker.tscn")
var lost : bool = false

@onready var pt = track.get_node_or_null("PositionTracker") as PositionTracker
@onready var gameover = get_node("%GameoverScreen") as Control
@onready var win_screen = get_node("%WinScreen") as Control
@onready var pause_timer = get_node("PauseTimer") as Timer

signal time_advance(delta : float)
signal part_collected(n_parts : int)
signal time_up()
signal win()

func _ready():
	for smoothing in get_tree().get_nodes_in_group("smoothing"):
		smoothing.teleport()
	for op in get_tree().get_nodes_in_group("organ_part"):
		n_organ_parts += 1
	get_tree().create_timer(level_load_buffer).timeout.connect(resume_time)
	gameover.hide()
	win_screen.hide()
	GameManager.state = GameManager.State.PLAYING

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
		
		if used_time >= time_limit and not lost:
			time_up.emit()
			show_gameover()
			lost = true
			pause_time()
			$Fail.play()
		else:
			used_time += delta_mod
			time_advance.emit(delta_mod)
	
	if is_instance_valid(timer_display):
		timer_display.set_time(time_limit - used_time)

func set_manual_advance(value : bool):
	manual_advance = value

func show_gameover():
	used_time = time_limit
	gameover.visible = true
	%Retry.grab_focus()

func show_success():
	pause_time()
	gameover.hide()
	timer_display.hide()
	%TimerDisplay2.set_time(timer_display.time)
	win_screen.show()
	%Continue.grab_focus()

func pause_time(length : float = 0.0):
	time_paused = true
	time_speed = 0.0
	%PauseIndicator.show()
	if not is_zero_approx(length):
		pause_timer.start(length)
		pause_timer.timeout.connect(resume_time, CONNECT_ONE_SHOT)

func resume_time():
	time_paused = false
	%PauseIndicator.hide()

func collect_organ_part(organ_part : OrganPart):
	parts_collected += 1
	part_collected.emit(parts_collected)
	if parts_collected == n_organ_parts:
		show_success()
		win.emit()
		$Fanfare.play()
	organ_part.queue_free()

func add_time(amount_sec : float):
	used_time -= amount_sec
	var tam = time_add_marker.instantiate()
	timer_display.add_child(tam)
	tam.set_relative_time(amount_sec)

func reload_level():
	get_tree().reload_current_scene()

func _on_retry_pressed():
	reload_level()

func _on_quit_pressed():
	if not OS.has_feature('web'):
		get_tree().quit()

func _on_continue_pressed():
	GameManager.change_scene(next_level)

func _unhandled_input(event):
	if event.is_action_pressed("test_button"):
		pause_time() if not time_paused else resume_time()
	if event.is_action_pressed("restart"):
		reload_level()
	if event.is_action_pressed("next_level"):
		GameManager.change_scene(next_level)

