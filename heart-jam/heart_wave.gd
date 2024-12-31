@tool
extends ColorRect

@onready
var mat = self.material
@export
var speed := 0.01
var progress := 0.0

func _process(delta):
	progress -= speed * delta
	if(progress <= 0.0):
		progress = 1.0
	
	mat.set_shader_parameter('radius', progress)
