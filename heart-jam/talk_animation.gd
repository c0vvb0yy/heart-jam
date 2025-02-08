extends Sprite2D

@export
var cool_down := 1.5

var original_rotation

var is_talking := false

func _init():
	original_rotation = self.rotation

func _process(delta):
	if(is_talking):
		cool_down -= delta
		if(cool_down <= 0):
			cool_down = 0.25
			self.rotation = original_rotation + deg_to_rad(randf_range(-10, 10))
	else:
		self.rotation = original_rotation
