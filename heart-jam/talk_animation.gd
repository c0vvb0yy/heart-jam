extends Sprite2D

@export
var cool_down := 1.5

var original_transform

func _init():
	original_transform = self.transform

func _process(delta):
	cool_down -= delta
	if(cool_down <= 0):
		cool_down = 0.25
		self.transform = original_transform.rotated_local(deg_to_rad(randf_range(-10, 10)))
