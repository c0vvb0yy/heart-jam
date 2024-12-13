shader_type canvas_item;
#include "res://shaders/constants.gdshaderinc"
#include "res://shaders/earthbound.gdshaderinc"

uniform sampler2D noise_texture : filter_linear_mipmap_anisotropic, repeat_enable;
uniform float noise_scale : hint_range(0.1, 10.0) = 1.0;
uniform float distortion_scale_x : hint_range(0.0, 10.0) = 0.03;
uniform float distortion_scale_y : hint_range(0.0, 10.0) = 0.03;
uniform float rainbow_intensity : hint_range(0.0, 1.0) = 0.5;
uniform float base_texture_degree : hint_range(0.0, 1.0) = 0.5;
uniform vec2 sprite_scroll_direction;
uniform float sprite_scroll_speed : hint_range(0.1, 10.0) = 1.0;
uniform float progress : hint_range(0.0, 1.0, 0.1) = 0.5;
uniform float debug : hint_range(0.0, 1.0) = 0.5;
uniform vec3 iridescence_base: source_color;

group_uniforms Horizontal_Wave;
uniform float horizontal_wave_amplitude : hint_range(-1.0, 1.0, 0.01) = 0.0;
uniform float horizontal_wave_frequency = 0.0;
uniform float horizontal_wave_speed = 1.0;

group_uniforms Vertical_Wave;
uniform float vertical_wave_amplitude : hint_range(-1.0, 1.0, 0.01) = 0.0;
uniform float vertical_wave_frequency = 0.0;
uniform float vertical_wave_speed = 1.0;


group_uniforms Horizontal_Deform;
uniform float horizontal_deform_amplitude : hint_range(-1.0, 1.0, 0.01) = 0.0;
uniform float horizontal_deform_frequency : hint_range(-1.0, 1.0, 0.01) = 0.0;
uniform float horizontal_deform_speed = 1.0;


group_uniforms Vertical_Deform;
uniform float vertical_deform_amplitude : hint_range(-10.0, 1.0, 0.01) = 0.0;
uniform float vertical_deform_frequency : hint_range(-10.0, 100.0, 0.01) = 0.0;
uniform float vertical_deform_speed = 1.0;

void fragment() {
    vec4 base_texture = texture(TEXTURE, UV);

    vec2 noise_uv = UV * noise_scale;
	float _progress = tan(TIME)* progress;
	noise_uv.y -= _progress / UV.y ;
    float noise_x = texture(noise_texture, noise_uv).r;
    float noise_y = texture(noise_texture, noise_uv).g;
	
	float def_x = calculate_diff(UV.x, tan(horizontal_deform_amplitude*TIME), horizontal_deform_frequency, horizontal_deform_speed);
	float def_y = calculate_diff(UV.y, tan(vertical_deform_amplitude), vertical_deform_frequency, vertical_deform_speed);
	float wav_x = calculate_diff(UV.y, horizontal_wave_amplitude, tan(sin(horizontal_wave_frequency * TIME)), horizontal_wave_speed);
	float wav_y = calculate_diff(UV.x, vertical_wave_amplitude, sin(asin(tan(vertical_wave_frequency))), vertical_wave_speed);
	
	vec2 move = calculate_move(sin(sprite_scroll_direction), sprite_scroll_speed);
	vec2 noise_uvs = vec2(UV.x + def_x + wav_x, UV.y + def_y + wav_y / TIME * progress+UV.y) + move;
	
	vec4 tex_copy = texture(noise_texture, noise_uvs+vec2(cos(TIME), sin(TIME*2.0))*0.2);
	tex_copy.a = progress;

    //vec2 distorted_uv = UV + vec2(noise_x * distortion_scale_x, noise_y * distortion_scale_y*normalized_sine());
	vec3 distorted_uv = vec3(
		UV.x+def_x + wav_x * normalized_sine()*sin(distortion_scale_x + 0.24),
		UV.y+def_y + wav_y * normalized_sine() * sin(distortion_scale_y),
		UV.y+def_y + wav_y / tan(TIME* progress+UV.y)) 
		+ vec3(move, move.x);
  // vec3 distorted_uv = vec3(UV.x+def_x + wav_x, UV.y+def_y + wav_y / tan(TIME* progress+UV.y), UV.y+def_y+wav_x / tan(TIME* progress+UV.x)) ;//+ vec3(move, move.y);
 	float rainbow_r = sin(distorted_uv.x * 15.0 + TIME * 0.1) * iridescence_base.r;
    float rainbow_g = sin(distorted_uv.y * 20.0 + TIME * 0.1 + 2.0) * iridescence_base.g;
    float rainbow_b = sin(distorted_uv.y * 15.0 + TIME * 0.1 + 4.0) * iridescence_base.b;

    vec4 rainbow_color = vec4(rainbow_r, rainbow_g, rainbow_b, tex_copy.a);
    rainbow_color = (rainbow_color + 1.0) * 0.5; // Normalize to [0.0, 1.0]

	//rainbow_color *= tex_copy.rgba;
	rainbow_color = mix(rainbow_color, tex_copy, rainbow_intensity);
    vec3 final_color = mix(base_texture, rainbow_color, base_texture_degree).rgb;
    final_color = mix(base_texture, rainbow_color, base_texture_degree).rgb;
	
	if(distorted_uv.y * tex_copy.r * normalized_sine() >= debug*normalized_sine() ){
		final_color += mix(tex_copy, rainbow_color,rainbow_intensity).rgb;
	} else {
  		final_color *= mix(tex_copy, rainbow_color,rainbow_intensity).rgb;
	}
	//float alpha = mix(tex_copy.a, COLOR.a, debug);

	if(COLOR.r <= 0.1){
    	COLOR = vec4(final_color, COLOR.a);
	}
}