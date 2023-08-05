extends Camera2D

@export var target : Node2D
@export var shake_decay : float = 0.8
@export var max_shake : Vector2 = Vector2(100, 75)
@export var smooth_speed : float = 5.0

var noise_y : float = 0.0
var trauma : float = 0.0
var trauma_power : float = 2.0
var noise : FastNoiseLite
var tex : Image

func _ready():
	global_position = target.global_position
	reset_smoothing()
	force_update_scroll()

func _process(delta):
	if is_instance_valid(target):
		global_position = target.global_position
	if trauma > 0:
		trauma = max(trauma - shake_decay * delta, 0)
		shake(delta)

func add_trauma(amount):
	trauma = min(trauma + amount, 1.0)

func shake(delta):
	var amount = pow(trauma, trauma_power)
	noise_y += delta * 50
	offset.x = max_shake.x * amount * noise.get_noise_2d(noise.seed*2, noise_y)
	offset.y = max_shake.y * amount * noise.get_noise_2d(noise.seed*3, noise_y)
