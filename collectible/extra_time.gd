extends Collectible

@export var extra_time : float = 1.0

func _ready():
	super._ready()
	$Sprite/ExtraLabel.text = str(extra_time)

func _on_pickup(body):
	super._on_pickup(body)
	level.add_time(extra_time)
	if body is Player:
		body.play_pickup_sound()
	queue_free()
