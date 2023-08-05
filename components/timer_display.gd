class_name TimerDisplay
extends Label

var time : float = 0.0

func set_time(time_sec : float):
	time = time_sec
	var mins = int(time_sec) / 60
	var secs = fmod(time_sec, 60)
	if mins > 0:
		text = "%d:%02d:%02d" % [mins, int(secs), int((secs - floor(secs)) * 100)]
	else:
		text = "%02d:%02d" % [int(secs), int((secs - floor(secs)) * 100)]

func set_relative_time(time_sec : float):
	var mins = int(time_sec) / 60
	var secs = fmod(time_sec, 60)
	if mins > 0:
		text = "%+d:%02d:%02d" % [mins, int(secs), int((secs - floor(secs)) * 100)]
	else:
		text = "%+2d:%02d" % [int(secs), int((secs - floor(secs)) * 100)]
	if time_sec < 0.0:
		set("theme_override_colors/font_color", Color.RED)
	elif time_sec > 0.0:
		set("theme_override_colors/font_color", Color.LIME_GREEN)
