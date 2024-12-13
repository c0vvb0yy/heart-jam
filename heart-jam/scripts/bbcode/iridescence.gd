@tool
extends RichTextEffect
class_name Iridescence

var bbcode = "iridescence"

func _process_custom_fx(char_fx: CharFXTransform)->bool:
	var colors = ["AQUAMARINE", "AZURE", "BISQUE", "LAVENDER", "LEMON_CHIFFON", "LIGHT_SEA_GREEN", "PALE_VIOLET_RED"]
	var color_pos = (char_fx.range.x + int(sin(char_fx.elapsed_time * 4) + 1)) % len(colors)
	char_fx.color = colors[color_pos]
	return true
