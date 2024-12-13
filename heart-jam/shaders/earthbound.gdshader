shader_type canvas_item;
#include "res://shaders/earthbound.gdshaderinc"
// Bounding Battle Backgound shader by Youkuri, this shader is under the Creative Commons license so feel free to use it to your heart contents! No need of crediting or anything.
// NOTE: Filter *does* matter when it comes to palette cycling, Filtered sprites makes it look smoother and Unfiltered makes them change in an instant



group_uniforms Settings;
uniform bool snes_transparency = false;
uniform bool gba_transparency = false;
uniform bool vertex_deform = false;
uniform bool mix_base_texture = false;
uniform float mix_degree : hint_range(0.0, 1.0, 0.1) = 0.5;
uniform float _progress : hint_range(0.0, 1.0, 0.1) = 0.5;

group_uniforms Sprite_Scroll;
uniform vec2 sprite_scroll_direction = vec2(0.0, 0.0);
uniform float sprite_scroll_speed = 0.01;


group_uniforms GBA_Transparency;
uniform vec2 gba_transparency_scroll_direction = vec2(0.0, 0.0);
uniform float gba_transparency_scroll_speed = 0.01;
uniform float gba_transparency_value : hint_range(0.0, 1.0) = 0.5;


group_uniforms Horizontal_Wave;
uniform float horizontal_wave_amplitude = 0.0;
uniform float horizontal_wave_frequency = 0.0;
uniform float horizontal_wave_speed = 1.0;

group_uniforms Vertical_Wave;
uniform float vertical_wave_amplitude = 0.0;
uniform float vertical_wave_frequency = 0.0;
uniform float vertical_wave_speed = 1.0;


group_uniforms Horizontal_Deform;
uniform float horizontal_deform_amplitude = 0.0;
uniform float horizontal_deform_frequency = 0.0;
uniform float horizontal_deform_speed = 1.0;


group_uniforms Vertical_Deform;
uniform float vertical_deform_amplitude = 0.0;
uniform float vertical_deform_frequency = 0.0;
uniform float vertical_deform_speed = 1.0;


group_uniforms Scanlines;
uniform bool horizontal_scan_line = false;
uniform bool vertical_scan_line = false;
uniform float width = 0.0;
uniform float height = 0.0;


group_uniforms Palette_Cycling;
uniform bool enable_palette_cycling = false;
uniform float palette_cycling_speed = 0.1;
uniform sampler2D palette;

uniform sampler2D fractal :filter_nearest, repeat_enable;



void vertex(){
	if(vertex_deform){
		float def_x = calculate_diff(UV.x, sin(horizontal_deform_amplitude*TIME), horizontal_deform_frequency, horizontal_deform_speed);
		float def_y = calculate_diff(UV.y, sin(vertical_deform_amplitude*TIME), vertical_deform_frequency, vertical_deform_speed);
		float wav_x = calculate_diff(UV.y, horizontal_wave_amplitude, horizontal_wave_frequency, horizontal_wave_speed);
		float wav_y = calculate_diff(UV.x, vertical_wave_amplitude, vertical_wave_frequency, vertical_wave_speed);
		
		vec2 move = calculate_move(sprite_scroll_direction, sprite_scroll_speed);
		
		UV.x += def_x + wav_x;
		UV.y += def_y + wav_y;
		UV += move;
	}
}
void fragment(){
	
	float def_x = calculate_diff(UV.x, sin(horizontal_deform_amplitude*TIME), horizontal_deform_frequency, horizontal_deform_speed);
	float def_y = calculate_diff(UV.y, sin(vertical_deform_amplitude*TIME), vertical_deform_frequency, vertical_deform_speed);
	float wav_x = calculate_diff(UV.y, horizontal_wave_amplitude, horizontal_wave_frequency, horizontal_wave_speed);
	float wav_y = calculate_diff(UV.x, vertical_wave_amplitude, vertical_wave_frequency, vertical_wave_speed);
	
	vec2 move = calculate_move(sprite_scroll_direction, sprite_scroll_speed);
	
	
	if ( int( UV.y * height ) % 2 == 0 && snes_transparency)
	{
		
		wav_x = -wav_x;
		
	}
	
	
	vec4 textube = texture(TEXTURE, vec2(UV.x+def_x + wav_x, UV.y+def_y + wav_y) + move);
	
	
	if (gba_transparency)
	{
		
		float copy_wav_x = -calculate_diff(UV.y, horizontal_wave_amplitude, horizontal_wave_frequency, horizontal_wave_speed);
		vec4 tex_copy;
		
		
		if ( int( UV.y * height ) % 2 == 1 && snes_transparency)
		{
			
			copy_wav_x = -copy_wav_x;
			
		}
		
		if (gba_transparency_scroll_direction != vec2(0.0))
		{
			
			vec2 copy_move = calculate_move(gba_transparency_scroll_direction, gba_transparency_scroll_speed);
			tex_copy = texture(fractal, vec2(UV.x+def_x + copy_wav_x, UV.y+def_y + wav_y) + copy_move);
			
		}
		else tex_copy = texture(fractal, vec2(UV.x+def_x + copy_wav_x, UV.y+def_y + wav_y) + move);
		
		
		textube = mix(textube, tex_copy, gba_transparency_value);
		
	}
	
	
	float palette_swap = mod(textube.r - TIME*palette_cycling_speed, 1.0);
	
	
	if (enable_palette_cycling)
	{
		
		textube = vec4(texture(palette, vec2(palette_swap, 0)).rgb, textube.a);
		
	}
	
	COLOR = textube;
	COLOR.a = texture(TEXTURE, UV).a;
	if(mix_base_texture){
		COLOR *= mix(COLOR, texture(TEXTURE, UV), mix_degree);
	}
	
	if (horizontal_scan_line) COLOR.rgb = mix(vec4(0.0, 0.0, 0.0, 1.0), COLOR, float(int(UV.y * height) % 2)).rgb;
	if (vertical_scan_line) COLOR.rgb = mix(vec4(0.0, 0.0, 0.0, 1.0), COLOR, float(int(UV.x * width) % 2)).rgb;
	
}