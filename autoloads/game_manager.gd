extends Node

func get_level() -> Level:
	return get_tree().current_scene as Level

func change_scene(new_scene : PackedScene):
	get_tree().change_scene_to_packed(new_scene)
