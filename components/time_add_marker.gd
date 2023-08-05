extends TimerDisplay

func _ready():
	var tw = create_tween()
	tw.tween_property(self, "position:y", 20.0, 2.0)
	tw.parallel().tween_property(self, "modulate:a", 0.0, 2.0)
	tw.tween_callback(queue_free)
