extends Sprite2D

@export var default_crack_size := 0.01
@export var default_crack_count := 2

var crack_mat = self.get_material()
var target_crack_size := 0.0
var target_crack_count := 0.0

var crack_up_count_down = 0.3

func _ready():
	crack_mat.set_shader_parameter("size", default_crack_size)
	crack_mat.set_shader_parameter("strike_count", default_crack_count)
	self.rotation = deg_to_rad(randf_range(0.0, 360.0))

func _process(delta):
	crack_mat.set_shader_parameter("size", lerp(crack_mat.get_shader_parameter("size"), target_crack_size, 0.002))
	crack_up_count_down -= delta
	if(crack_up_count_down <= 0 && crack_mat.get_shader_parameter("strike_count") <= target_crack_count):
		crack_up_count_down = randf_range(0.1, 0.6)
		crack_mat.set_shader_parameter("strike_count", crack_mat.get_shader_parameter("strike_count") + 1)
