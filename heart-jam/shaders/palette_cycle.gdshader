shader_type canvas_item;
#include "res://shaders/constants.gdshaderinc"

uniform sampler2D gradient: repeat_enable;
uniform sampler2D noise;
uniform float speed_scale = 0.07;


void fragment() {
	vec4 input = texture(TEXTURE, UV);
	vec3 gradient_color = palette_swap_cycle(input, gradient, TIME*speed_scale).rgb;//texture(gradient, vec2(input.r + TIME * speed_scale, 0.0)).rgb;
	COLOR.rgb = gradient_color;
}

