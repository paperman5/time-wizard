class_name TimerDisplay
extends Label

func set_time(time_sec : float):
	var mins = int(time_sec) / 60
	var secs = fmod(time_sec, 60)
	if mins > 0:
		text = "%d:%02d:%02d" % [mins, int(secs), int((secs - floor(secs)) * 100)]
	else:
		text = "%02d:%02d" % [int(secs), int((secs - floor(secs)) * 100)]
