class_name Collectible
extends Area2D

@export var pickup_text : String

var tw : Tween
var level : Level
var pickup_text_scene = preload("res://collectible/pickup_text.tscn")

func _ready():
	level = GameManager.get_level()
	level.time_advance.connect(process_tween)
	body_entered.connect(_on_pickup)
	play_hover()

func play_hover():
	tw = create_tween()
	tw.tween_property(%Sprite, "position:y", 4.0, 2.0).set_trans(Tween.TRANS_SINE)
	tw.tween_property(%Sprite, "position:y", -4.0, 2.0).set_trans(Tween.TRANS_SINE)
	tw.set_loops()
	tw.pause()
	
	var tw2 = create_tween()
	tw2.tween_property(%Glow, "scale", Vector2.ONE * 1.3, 2.0).set_trans(Tween.TRANS_SINE)
	tw2.tween_property(%Glow, "scale", Vector2.ONE * 0.5, 2.0).set_trans(Tween.TRANS_SINE)
	tw2.set_loops()

func process_tween(delta):
	if is_instance_valid(tw):
		tw.custom_step(delta)

func show_glow(v : bool = true):
	$Glow.visible = v

func _on_pickup(body : Node2D):
	var o = pickup_text_scene.instantiate()
	get_parent().add_child(o)
	o.position = global_position
	o.get_node("Label").text = pickup_text
	o.get_node("Timer").timeout.connect(o.queue_free)
