extends TextureRect

@export var bop_length := 10

func _ready():
	var tween = create_tween().set_loops()
	tween.tween_property(self, "position:x", self.position.x - bop_length, 1.8).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT).set_delay(0.1)
	tween.chain().tween_property(self, "position:x", self.position.x + bop_length, 1.8).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT).set_delay(0.1)
