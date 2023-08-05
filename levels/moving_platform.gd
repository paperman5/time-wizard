extends AnimatableBody2D

@export var first_wait_time : float = 0.0
@export var second_wait_time : float = 0.0
@export var travel_time : float = 1.0

var level : Level
var tw : Tween

func _ready():
	level = GameManager.get_level()
	level.time_advance.connect(update_tween)
	var dist = (%Second.global_position - %First.global_position).length()
	var first_dist = (global_position - %First.global_position).length()
	var second_dist = (global_position - %Second.global_position).length()
	tw = create_tween()
	tw.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	if global_position.is_equal_approx(%First.global_position):
		tw.tween_interval(first_wait_time)
	else:
		tw.tween_property(self, "global_position", %First.global_position, travel_time * first_dist / dist)
		tw.tween_interval(first_wait_time)
	tw.finished.connect(start_loop)
	tw.pause()

func start_loop():
	tw = create_tween()
	tw.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tw.tween_property(self, "global_position", %Second.global_position, travel_time)
	tw.tween_interval(second_wait_time)
	tw.tween_property(self, "global_position", %First.global_position, travel_time)
	tw.tween_interval(first_wait_time)
	tw.set_loops()
	tw.pause()

func update_tween(delta):
	tw.custom_step(delta)
