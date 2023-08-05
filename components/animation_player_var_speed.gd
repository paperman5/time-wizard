class_name AnimationPlayerVariableSpeed
extends AnimationPlayer

@export var level : Level

func _ready():
	playback_process_mode = AnimationPlayer.ANIMATION_PROCESS_MANUAL
	if not is_instance_valid(level):
		push_warning("AnimationPlayerVariableSpeed is not connected to level")
		return
	level.time_advance.connect(variable_advance)

func variable_advance(delta):
	if is_playing():
		advance(delta)
