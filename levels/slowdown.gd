extends Area2D

@export var slowdown_percent : float = 0.5

var prev_max_speed : float = 0.0

func _on_body_entered(body):
	if body is Player:
		prev_max_speed = body.max_speed
		body.max_speed = body.max_speed * slowdown_percent

func _on_body_exited(body):
	if body is Player:
		body.max_speed = prev_max_speed
