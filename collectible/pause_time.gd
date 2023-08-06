extends Collectible

@export var pause_length : float = 1.0

func _ready():
	super._ready()
	$Sprite/ExtraLabel.text = str(pause_length)

func _on_pickup(body):
	super._on_pickup(body)
	level.pause_time(pause_length)
	if body is Player:
		body.play_pickup_sound()
	queue_free()
