extends Node2D

@export var time_limit : float = 65.0
@export var timer_display : TimerDisplay
@export var track : Node2D

var used_time : float = 0.0
var prev

@onready var pt = track.get_node_or_null("PositionTracker") as PositionTracker

func _process(delta):
	if is_instance_valid(pt):
		var speed = min((pt.global_position - pt.prev).length() / delta, pt.top_speed)
		used_time += delta * speed / pt.top_speed
	if is_instance_valid(timer_display):
		timer_display.set_time(time_limit - used_time)
