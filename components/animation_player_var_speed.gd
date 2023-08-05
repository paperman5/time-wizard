class_name AnimationPlayerVariableSpeed
extends AnimationPlayer

var level : Level

func _ready():
	level = GameManager.get_level()
	playback_process_mode = AnimationPlayer.ANIMATION_PROCESS_MANUAL
	if not is_instance_valid(level):
		push_warning("AnimationPlayerVariableSpeed is not connected to level")
		return
	level.time_advance.connect(variable_advance)

func variable_advance(delta):
	if is_playing():
		advance(delta)
