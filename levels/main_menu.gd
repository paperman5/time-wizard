extends Control

@export var first_level : PackedScene

var story : int = 0
var max_story : int = 4

func _ready():
	for c in get_children():
		c.hide()
	%Menu.show()

func _on_play_pressed():
	%Menu.hide()
	%Credits.hide()
	var o = get_node_or_null("Story"+str(story))
	if o != null : o.visible = false
	story += 1
	o = get_node_or_null("Story"+str(story))
	if o != null: o.visible = true
	if story > max_story:
		GameManager.change_scene(first_level)


func _on_back_pressed():
	for c in get_children():
		c.hide()
	%Menu.show()


func _on_credits_pressed():
	for c in get_children():
		c.hide()
	%Credits.show()

func show_ending():
	for c in get_children():
		c.hide()
	$Ending1.show()
