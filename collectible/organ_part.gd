class_name OrganPart
extends Collectible

func _on_pickup(body):
	level.collect_organ_part()
	queue_free()
