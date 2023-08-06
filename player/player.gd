class_name Player
extends CharacterBody2D

@export_category("Max Speed")
@export var max_speed : float = 120.0
@export var max_fall_speed : float = 300.0
@export_category("Accel/Decel")
@export var gnd_accel : float = 500.0
@export var gnd_decel : float = 500.0
@export var air_accel : float = 500.0
@export var air_decel : float = 50.0
@export_category("Jumping")
@export var jump_height : float = 35.0
@export var jump_apex_time : float = 0.3
@export var coyote_jump_frames : int = 4
@export var jump_buffer_frames : int = 4
@export var default_jumps : int = 2
@export var air_jump_percent_height : float = 1.0
@export_category("Wall Jumping")
@export var wall_cling_time : float = 0.15
@export var wall_detatch_time : float = 0.2
@export var wall_cling_speed_threshold : float = 250.0
@export var wall_slide_speed : float = 20.0
@export var wall_jump_horizontal_speed : float = 90.0

var level : Level
var jump_speed : float
var gravity : Vector2
var _input_ud : Vector2 = Vector2.ZERO
var _input_lr : Vector2 = Vector2.ZERO
var deadzone : float = 0.1
var jumps = default_jumps
var airtime : float = 0.0
var did_walljump : bool = false

#@onready var state_label := get_node("%StateLabel") as Label
@onready var right_raycast := get_node("RightRaycast") as RayCast2D
@onready var left_raycast := get_node("LeftRaycast") as RayCast2D
@onready var anim := $AnimationPlayer as AnimationPlayer

signal jumped()

func _ready():
	level = GameManager.get_level()
	if is_instance_valid(level):
		jumped.connect(func(): level.add_time(-1.0))
		level.time_up.connect(die)
		level.win.connect(disable)
	recalc_physics()
	if not is_instance_valid(level):
		push_warning("Player is not connected to level")

func recalc_physics():
	jump_speed = 2 * jump_height / jump_apex_time
	gravity = 2 * jump_height / (pow(jump_apex_time, 2)) * Vector2.DOWN

func get_input_direction() -> Vector2:
	var input = Vector2(_input_lr.y - _input_lr.x, _input_ud.y - _input_ud.x)
	return input if input.length() > deadzone else Vector2.ZERO

func jump(reduce_jumps : bool = true, type : String = 'ground'):
	if jumps > 0:
		if type == 'ground':
			velocity.y = -jump_speed
		elif type == 'air':
			velocity.y = -jump_speed * air_jump_percent_height
		airtime = 0.0
		if reduce_jumps:
			jumps -= 1
		jumped.emit()
		anim.play("jump")
		$JumpSound.play()

func play_pickup_sound():
	$PickupSound.play()

func reset_jumps():
	jumps = default_jumps

func set_facing(left : bool):
	%Sprite2D.flip_h = left

func _unhandled_input(event):
	if event.is_action_pressed("move_left"):
		_input_lr.x = event.get_action_strength("move_left")
	elif event.is_action_pressed("move_right"):
		_input_lr.y = event.get_action_strength("move_right")
	
	elif event.is_action_released("move_left"):
		_input_lr.x = 0
	elif event.is_action_released("move_right"):
		_input_lr.y = 0
	
	elif event.is_action_pressed("advance_time"):
		level.manual_advance = true
	elif event.is_action_released("advance_time"):
		level.manual_advance = false

func set_state_label(text : String):
#	state_label.text = text
	pass

func die():
	%Sprite2D.visible = false
	%Explode.visible = true
	%Explode.play("default")
	%Explode.animation_finished.connect(%Explode.pause)
	$StateMachine.transition_to("None")

func disable():
	$StateMachine.transition_to("None")
	anim.play("idle")
