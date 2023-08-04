# Air.gd
extends PlayerState

var jump_pressed := false
var time_since_jump_pressed := 0.0 # for jump buffering
var airtime : float = 0.0
var coyote_jump_threshold : float
var jump_buffer_threshold : float

# If we get a message asking us to jump, we jump.
func enter(msg := {}) -> void:
	player.state_label.text = "AIR"
	if msg.has("do_jump"):
		player.jump()
	coyote_jump_threshold = float(player.coyote_jump_frames) / 60.0
	jump_buffer_threshold = float(player.jump_buffer_frames) / 60.0

func update(delta):
	var input_direction: Vector2 = player.get_input_direction()
	
	airtime += delta
	if jump_pressed:
		time_since_jump_pressed += delta

func physics_update(delta: float) -> void:
	
	var input_direction: Vector2 = player.get_input_direction()
	var accel_x : Vector2
	if not is_equal_approx(input_direction.x, 0.0):
		accel_x = player.air_accel * input_direction
	else:
		accel_x = -sign(player.velocity.x) * player.air_decel * Vector2.RIGHT
	
	# movement & gravity
	player.velocity += (player.gravity + accel_x) * delta
	player.velocity.x = sign(player.velocity.x) * clamp(abs(player.velocity.x), 0, player.max_speed)
	player.velocity.y = sign(player.velocity.y) * clamp(abs(player.velocity.y), 0, player.max_fall_speed)
	
	player.move_and_slide()
	
	# "coyote jumping" for a couple frames after leaving a ledge
	if Input.is_action_just_pressed("jump"):
		if airtime <= coyote_jump_threshold:
			player.jump()
		else:
			jump_pressed = true
			time_since_jump_pressed = 0.0

	# Landing.
	if player.is_on_floor():
		airtime = 0.0
		var msg = {from_air = true}
		if time_since_jump_pressed <= jump_buffer_threshold and jump_pressed:
			msg = {jump_buffered = true}
			
		if is_zero_approx(player.velocity.x):
			state_machine.transition_to("Idle", msg)
		else:
			state_machine.transition_to("Run", msg)
