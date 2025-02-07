extends Node2D
class_name Act1Vis

@onready var base = $Room
@onready var filter = $Room2
@onready var cracks_shader = $Cracks.get_material()
@onready var cracks_shader_2 = $Cracks2.get_material()
var switch = true

func glitch(loops: float):
	#filter.modulate.a = 0
	#filter.visible = true
	#char_fx.glyph_index += tan((sin(char_fx.elapsed_time) * speed)*glitchiness) *magnitude +magnitude
	#var tween = create_tween().set_loops(5)
	#tween.tween_callback(flicker).set_delay(1.75)
	cracks_shader.set_shader_parameter("size", loops)
	#cracks_shader_2.set_shader_parameter("size", loops)

func flicker():
	print("flicker")
	filter.visible = !filter.visible

func apply_filter(is_visible):
	filter.visible = is_visible
