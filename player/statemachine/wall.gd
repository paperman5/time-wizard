extends PlayerState

var cling_timer : float = 0.0
var side : int = 0

func enter(msg := {}) -> void:
	player.state_label.text = "WALL"
	player.reset_jumps()
	cling_timer = 0.0

func update(delta):
	cling_timer += delta

func physics_update(delta):
	var input_direction: Vector2 = player.get_input_direction()
	var accel := Vector2.ZERO
	side = int(player.right_raycast.is_colliding()) - int(player.left_raycast.is_colliding())
	
	if player.is_on_wall_only():
		accel.x = player.air_accel * input_direction.x
		if is_zero_approx(input_direction.x):
			# Add a small amount of horizontal accel to make it collide with wall
			player.velocity.x = 100.0 * side
	
	# movement & gravity
	player.velocity += ((player.gravity * float(cling_timer > player.wall_cling_time)) + accel) * delta
	player.velocity.x = sign(player.velocity.x) * clamp(abs(player.velocity.x), 0, player.max_speed)
	player.velocity.y = sign(player.velocity.y) * clamp(abs(player.velocity.y), 0, player.wall_slide_speed)
	
	player.move_and_slide()
	
	var msg = {"from_wall" = true}
	if player.is_on_floor():
		if is_zero_approx(player.velocity.x):
			state_machine.transition_to("Idle", msg)
		else:
			state_machine.transition_to("Run", msg)
	elif not player.is_on_wall() or side == 0:
		state_machine.transition_to("Air", msg)
	
	if Input.is_action_just_pressed("jump"):
		player.jump()
		player.did_walljump = true
		state_machine.transition_to("Air", msg)
