extends Collectible

@export var pause_length : float = 1.0

func _on_pickup(body):
	super._on_pickup(body)
	level.pause_time(pause_length)
	queue_free()
