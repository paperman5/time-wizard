extends PlayerState

func enter(msg := {}) -> void:
	player.state_label.text = "RUN"
	player.reset_jumps()
	if msg.has("jump_buffered"):
		state_machine.transition_to("Air", {do_jump = true})

func physics_update(delta: float) -> void:

	var input_direction: Vector2 = player.get_input_direction()
	var accel : Vector2
	if not is_equal_approx(input_direction.x, 0.0):
		accel = player.gnd_accel * input_direction
	else:
		accel = -sign(player.velocity.x) * player.gnd_decel * Vector2.RIGHT
		# handle stopping due to friction
		if sign(player.velocity.x + accel.x*delta) * sign(player.velocity.x) < 0: #change in direction
			if not is_zero_approx(delta):
				accel.x = -player.velocity.x / delta
	
	# movement & gravity
	player.velocity += (player.gravity + accel) * delta
	player.velocity.x = sign(player.velocity.x) * clamp(abs(player.velocity.x), 0, player.max_speed)
	player.velocity.y = sign(player.velocity.y) * clamp(abs(player.velocity.y), 0, player.max_fall_speed)
	
	player.move_and_slide()
	
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		return

	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Air", {do_jump = true})
	elif is_zero_approx(input_direction.x) and is_zero_approx(player.velocity.x):
		state_machine.transition_to("Idle")
