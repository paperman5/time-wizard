extends Collectible

@export var extra_time : float = 1.0

func _on_pickup(body):
	level.add_time(extra_time)
	queue_free()
