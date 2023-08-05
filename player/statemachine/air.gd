# Air.gd
extends PlayerState

var jump_pressed := false
var time_since_jump_pressed := 0.0 # for jump buffering
var coyote_jump_threshold : float
var jump_buffer_threshold : float
var coyote_failed : bool = false
var from_wall : bool = false

# If we get a message asking us to jump, we jump.
func enter(msg := {}) -> void:
	player.set_state_label("AIR")
	coyote_failed = false
	from_wall = false
	if msg.has("do_jump"):
		player.jump()
		coyote_failed = true
	if msg.has("from_wall"):
		coyote_failed = true
		from_wall = true
	coyote_jump_threshold = float(player.coyote_jump_frames) / 60.0
	jump_buffer_threshold = float(player.jump_buffer_frames) / 60.0

func update(delta):
	player.airtime += delta
	if jump_pressed:
		time_since_jump_pressed += delta
	if player.airtime > coyote_jump_threshold and not coyote_failed:
		player.jumps -= 1
		coyote_failed = true

func physics_update(delta: float) -> void:
	
	var input_direction: Vector2 = player.get_input_direction()
	var accel : Vector2
	if not is_zero_approx(input_direction.x):
		accel = player.air_accel * input_direction
		player.set_facing(input_direction.x < 0.0)
	else:
		accel = -sign(player.velocity.x) * player.air_decel * Vector2.RIGHT
	
	# movement & gravity
	player.velocity += (player.gravity + accel) * delta
	player.velocity.x = sign(player.velocity.x) * clamp(abs(player.velocity.x), 0, player.max_speed)
	player.velocity.y = sign(player.velocity.y) * clamp(abs(player.velocity.y), 0, player.max_fall_speed)
	
	player.move_and_slide()
	
	# "coyote jumping" for a couple frames after leaving a ledge
	if Input.is_action_just_pressed("jump"):
		player.jump()
		coyote_failed = true
		jump_pressed = true
		time_since_jump_pressed = 0.0
		if from_wall == true:
			player.did_walljump = true
	
	if player.is_on_wall_only():
		pass
	
	if player.is_on_wall_only() \
				and (not is_zero_approx(input_direction.x) or player.right_raycast.is_colliding() or player.left_raycast.is_colliding()) \
				and player.velocity.y < player.wall_cling_speed_threshold \
				and player.velocity.y > 0.0\
				and not player.did_walljump:
		player.airtime = 0.0
		state_machine.transition_to("Wall")
		return
	
	# Landing.
	if player.is_on_floor():
		player.airtime = 0.0
		var msg = {from_air = true}
		if time_since_jump_pressed <= jump_buffer_threshold and jump_pressed:
			msg = {jump_buffered = true}
			
		if is_zero_approx(player.velocity.x):
			state_machine.transition_to("Idle", msg)
		else:
			state_machine.transition_to("Run", msg)
