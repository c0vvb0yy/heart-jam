shader_type canvas_item;
#include "res://shaders/constants.gdshaderinc"

uniform float scroll_speed: hint_range(0.0, 1.0, 0.1);
uniform float debug: hint_range(0.0, 1.0, 0.1);
uniform sampler2D overlay_input: repeat_enable;


vec2 scale(vec2 uv, float x, float y){
	mat2 scale = mat2(vec2(x, 0.0), vec2(0.0,y));
	
	uv -= 0.5;
	uv = uv * scale;
	uv += 0.5;
	return uv;
}
float circle(vec2 position, float radius, float feather)
{
	return smoothstep(radius, radius + feather, length(position - vec2(0.5)));
}
uniform float sway_speed = 1.0;
uniform float sway_strength = 0.05;
uniform float sway_phase_len = 8.0;

void vertex(){
	float strength = COLOR.r * sway_strength;
    VERTEX.x += sin(VERTEX.x * sway_phase_len * 1.123 + TIME * sway_speed) * strength;
    VERTEX.y += sin(VERTEX.y * sway_phase_len + TIME * sway_speed * 1.12412) * strength;
	//VERTEX.x *= 2.1;
}

void fragment() {
	float strength = COLOR.r * sway_strength;
	vec2 input_uvs = vec2(sin(UV.x * sway_phase_len * 1.123 + TIME * sway_speed) * strength, sin(UV.y * sway_phase_len + TIME * sway_speed * 1.12412) * strength);
	vec4 input = texture(TEXTURE, UV);
	vec2 overlay_uvs = UV;
	overlay_uvs.y *= 2.1;
	vec4 overlay = texture(overlay_input, input_uvs + TIME * scroll_speed);
	//input.a = debug;
	//input.rgb *= overlay.rgb;
	//input = mix(input, overlay, debug);
	//input = smoothstep(input, overlay, vec4(debug));
	//input = smoothstep(input, overlay, vec4(normalized_sine()));
	//overlay = refract(input, overlay, 1.0);
	input -= overlay;
	//COLOR.rgb /= overlay.rgb;
	COLOR = input;
	vec2 scale = scale(UV, debug, debug);
	//COLOR += circle(scale, 0.2, 0.001);
	//COLOR = overlay;
}


//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
