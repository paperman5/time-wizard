extends Node

var main_menu_music = preload("res://music/upbeat-funk-commercial-intro.mp3")
var playing_music = preload("res://music/upbeat-funk-commercial-112624.mp3")
var main_menu = preload("res://levels/main_menu.tscn")

enum State {
	MAIN_MENU,
	PLAYING
}

var state = State.MAIN_MENU
var music_player : AudioStreamPlayer

func _ready():
	music_player = AudioStreamPlayer.new()
	music_player.bus = "Music"
	add_child(music_player)
	music_player.stream = main_menu_music
	music_player.play()

func get_level() -> Level:
	return get_tree().current_scene as Level

func change_scene(new_scene : PackedScene):
	if new_scene != null:
		if state == State.MAIN_MENU:
			var time = music_player.get_playback_position()
			music_player.stop()
			music_player.stream = playing_music
			music_player.play(time)
		state = State.PLAYING
		get_tree().change_scene_to_packed(new_scene)
	elif state == State.PLAYING:
		get_tree().change_scene_to_packed(main_menu)
		call_deferred("try_show_ending")

func try_show_ending():
	var s = get_tree().current_scene
	if s.has_method("show_ending"):
		s.show_ending()
