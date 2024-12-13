@tool
extends RichTextEffect
class_name Glitch

var bbcode = "glitch"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var magnitude = char_fx.env.get("magnitude", 1)
	var glitchiness = char_fx.env.get("glitchiness", 1)
	var speed = char_fx.env.get("speed", 1)
	#char_fx.glyph_index += sin(tan(char_fx.elapsed_time)) *randi_range(1, magnitude) +randi_range(1, magnitude)
	var ran = randi_range(0,magnitude)
	char_fx.glyph_index += tan((sin(char_fx.elapsed_time) * speed)*glitchiness) *magnitude +magnitude
	#char_fx.glyph_index += int(char_fx.elapsed_time) % int(tan(sin(char_fx.elapsed_time * speed)*glitchiness))
	#char_fx.glyph_index += randi_range(1, 53)
	return true
