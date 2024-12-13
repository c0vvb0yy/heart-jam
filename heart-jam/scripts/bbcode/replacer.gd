@tool
extends RichTextEffect
class_name Replacer

var bbcode = "replacer"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var simple = char_fx.env.get("simple", false)
	var replacement = char_fx.env.get("prim_repl", ["t","e","s","t", " "])
	var sec_repl = char_fx.env.get("sec_repl", ["æ", "e", "c"])
	var text_server = TextServerManager.get_primary_interface()
	
		#var wave = sin(char_fx.elapsed_time*50)*0.5 +0.5
		#char_fx.glyph_index = text_server.font_get_glyph_index(char_fx.font, 16, replacement[char_fx.relative_index % len(replacement)].unicode_at(0), 0)
	var wave = tan(sin(char_fx.elapsed_time * 1.5)*1.5) *0.8 +0.8
	#from -10 to 12
	#char_fx.glyph_index += wave
	if(wave <= 12 and wave >= 6 || wave <= -4 and wave >= -10):
		if(randi() % 2 == 0):
			char_fx.glyph_index = text_server.font_get_glyph_index(char_fx.font, 16, replacement[char_fx.relative_index % len(replacement)].unicode_at(0), 0)
		else: 
			char_fx.glyph_index = text_server.font_get_glyph_index(char_fx.font, 16, sec_repl[char_fx.relative_index % len(sec_repl)].unicode_at(0), 0)
			

	return true
#var colors = ["AQUAMARINE", "AZURE", "BISQUE", "LAVENDER", "LEMON_CHIFFON", "LIGHT_SEA_GREEN", "PALE_VIOLET_RED"]
	#var color_pos = (char_fx.range.x + int(sin(char_fx.elapsed_time * 4) + 1)) % len(colors)
	#char_fx.color = colors[color_pos]
