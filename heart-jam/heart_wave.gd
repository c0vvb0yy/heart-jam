@tool
extends Sprite2D

@onready
var mat = self.material
@export
var speed := 0.1
var progress := 0.0

func _process(delta):
	progress -= speed * delta
	if(progress <= 0.0):
		progress = 10.0
	mat.set_shader_parameter('glow_strength', sin(progress)*5)
	#mat.set_shader_parameter('radius', progress)
