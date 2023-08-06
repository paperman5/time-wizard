class_name OrganPart
extends Collectible

@export var play_collect_sound : bool = true

func _on_pickup(body):
	super._on_pickup(body)
	level.collect_organ_part(self)
	if body is Player and play_collect_sound:
		body.play_pickup_sound()
