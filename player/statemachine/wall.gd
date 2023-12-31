extends PlayerState

var cling_timer : float = 0.0
var detatch_timer : float = 0.0
var side : int = 0

func enter(_msg := {}) -> void:
	player.set_state_label("WALL")
	player.anim.play("wall_cling")
	player.reset_jumps()
	cling_timer = 0.0
	detatch_timer = 0.0

func update(delta):
	var input_direction: Vector2 = player.get_input_direction()
	cling_timer += delta
	if side == -sign(input_direction.x) and side != 0:
		detatch_timer += delta
	else:
		detatch_timer = 0.0

func physics_update(delta):
	var input_direction: Vector2 = player.get_input_direction()
	var accel := Vector2.ZERO
	side = int(player.right_raycast.is_colliding()) - int(player.left_raycast.is_colliding())
	
	if player.is_on_wall_only():
		accel.x = player.air_accel * input_direction.x
#		if is_zero_approx(input_direction.x):
#			# Add a small amount of horizontal accel to make it collide with wall
#			player.velocity.x = 100.0 * side
	
	# movement & gravity
	player.velocity += ((player.gravity * float(cling_timer > player.wall_cling_time)) + accel) * delta
	if side == -1:
		player.velocity.x = clamp(player.velocity.x, -player.max_speed, -100.0)
	elif side == 1:
		player.velocity.x = clamp(player.velocity.x, 100.0, player.max_speed)
#	player.velocity.x = sign(player.velocity.x) * clamp(abs(player.velocity.x), 0, player.max_speed)
	player.velocity.y = sign(player.velocity.y) * clamp(abs(player.velocity.y), 0, player.wall_slide_speed)
	
	player.move_and_slide()
	
	var msg = {"from_wall" = true}
	if player.is_on_floor():
		if is_zero_approx(player.velocity.x):
			state_machine.transition_to("Idle", msg)
		else:
			state_machine.transition_to("Run", msg)
	elif not player.is_on_wall() or side == 0 or detatch_timer >= player.wall_detatch_time:
		state_machine.transition_to("Air", msg)
	
	if Input.is_action_just_pressed("jump"):
		player.jump()
		player.did_walljump = true
		player.velocity.x = -side * player.wall_jump_horizontal_speed
		state_machine.transition_to("Air", msg)
