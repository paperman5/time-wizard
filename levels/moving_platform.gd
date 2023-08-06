extends AnimatableBody2D

@export var first_wait_time : float = 0.0
@export var second_wait_time : float = 0.0
@export var travel_time : float = 1.0
@export var initial_wait_time : float = 0.0

var level : Level
var tw : Tween
var first_point : Vector2
var second_point : Vector2

func _ready():
	level = GameManager.get_level()
	level.time_advance.connect(update_tween)
	first_point = %First.global_position
	second_point = %Second.global_position
	var dist = (%Second.global_position - first_point).length()
	var first_dist = (global_position - first_point).length()
	var second_dist = (global_position - second_point).length()
	tw = create_tween()
	tw.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tw.tween_interval(initial_wait_time)
	if global_position.is_equal_approx(first_point):
		tw.tween_interval(first_wait_time)
	else:
		tw.tween_property(self, "global_position", first_point, travel_time * first_dist / dist)
		tw.tween_interval(first_wait_time)
	tw.finished.connect(start_loop)
	tw.pause()

func start_loop():
	tw = create_tween()
	tw.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tw.tween_property(self, "global_position", second_point, travel_time)
	tw.tween_interval(second_wait_time)
	tw.tween_property(self, "global_position", first_point, travel_time)
	tw.tween_interval(first_wait_time)
	tw.set_loops()
	tw.pause()

func update_tween(delta):
	tw.custom_step(delta)
