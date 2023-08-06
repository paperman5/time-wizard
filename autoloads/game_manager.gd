extends Node

var main_menu_music = preload("res://music/upbeat-funk-commercial-intro.mp3")
var playing_music = preload("res://music/upbeat-funk-commercial-112624.mp3")
var main_menu = null

enum State {
	MAIN_MENU,
	PLAYING
}

var state = State.MAIN_MENU
var music_player : AudioStreamPlayer

func _ready():
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.stream = main_menu_music
	music_player.play()

func get_level() -> Level:
	return get_tree().current_scene as Level

func change_scene(new_scene : PackedScene):
	if new_scene != main_menu:
		if state == State.MAIN_MENU:
			var time = music_player.get_playback_position()
			music_player.stop()
			music_player.stream = playing_music
			music_player.play(time)
		state = State.PLAYING
	get_tree().change_scene_to_packed(new_scene)
