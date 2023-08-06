extends PlayerState

# Upon entering the state, we set the Player node's velocity to zero.
func enter(msg := {}) -> void:
	player.velocity = Vector2.ZERO

func physics_update(delta: float) -> void:
	pass
