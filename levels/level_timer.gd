extends Label

@export var track : Node

var value : float = 0.0
var prev := Vector2.ZERO

@onready var timer_tracker := track.get_node_or_null("TimerTracker") as TimerTracker

func _ready():
	if timer_tracker != null:
		prev = timer_tracker.global_position

func _process(delta):
	if timer_tracker != null:
		var speed = (timer_tracker.global_position - prev).length() / delta
		value += delta * speed / timer_tracker.top_speed
		prev = timer_tracker.global_position
		text = str(snapped(value, 0.001))
