@tool
extends TextureRect

@export var speed := 10

func _ready():
	var tween = create_tween().set_loops()
	tween.tween_property(self, "rotation_degrees", 360, speed).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT).from(0)
