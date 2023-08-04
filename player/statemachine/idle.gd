extends PlayerState

# Upon entering the state, we set the Player node's velocity to zero.
func enter(msg := {}) -> void:
	player.state_label.text = "IDLE"
	player.reset_jumps()
	if msg.has("jump_buffered"):
		state_machine.transition_to("Air", {do_jump = true})
	else:
		player.velocity = Vector2.ZERO

func physics_update(delta: float) -> void:
	# If you have platforms that break when standing on them, you need that check for 
	# the character to fall.
	player.velocity += player.gravity * delta
	player.velocity.y = sign(player.velocity.y) * clamp(abs(player.velocity.y), 0, player.max_fall_speed)
	player.move_and_slide()
	
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		return
	
	var input_dir = player.get_input_direction()
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Air", {do_jump = true})
	elif not is_zero_approx(input_dir.x):
		state_machine.transition_to("Run")
