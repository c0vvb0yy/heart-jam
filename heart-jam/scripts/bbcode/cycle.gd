@tool
extends RichTextEffect
class_name Cycle

var bbcode = "cycle"
var set_glyphs = [""]
var shuffled = false

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var word = char_fx.env.get("word", ["t","e","s","t"])
	set_glyphs.resize(len(word))
	var text_server = TextServerManager.get_primary_interface()
	if(int(char_fx.elapsed_time*20) % 2 == 0):
		#var new_char = word[int(randi_range(0, len(word)-1)+char_fx.relative_index) % len(word)]
		#var new_char = word[int(char_fx.elapsed_time*40+char_fx.relative_index) % len(word)]
		if(!shuffled):
			word.shuffle()
			shuffled = true
		var new_char = word[char_fx.relative_index % len(word)]
		set_glyphs[char_fx.relative_index] = new_char
		char_fx.glyph_index = text_server.font_get_glyph_index(char_fx.font, 16, new_char.unicode_at(0), 0)
		
	else:
		char_fx.glyph_index = text_server.font_get_glyph_index(char_fx.font, 16, set_glyphs[char_fx.relative_index].unicode_at(0), 0)
		if(shuffled): 
			shuffled = false
	return true
