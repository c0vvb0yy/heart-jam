shader_type canvas_item;
#include "constants.gdshaderinc"

group_uniforms Frag_unis;
uniform float aurora_scroll_speed: hint_range(0.0, 1.0, 0.1) = .2;
uniform float color_scroll_speed: hint_range(0.0, 5.0, 0.1) = 1.2;
uniform sampler2D lower_transparency_mask :repeat_enable;
uniform float curve_horizontal_repition: hint_range(1.0, 10.0, 0.0001);
uniform float glow_strength: hint_range(0.0, 10.0, 0.01) = 3.;
uniform float debug: hint_range(0.0, 1.0, 0.01) = 0.;
uniform float base_white_size: hint_range(0.0, 10.0, 0.01) = 1.5;
uniform sampler2D gradient_base :repeat_enable;
uniform vec4 tint: source_color = vec4(0.3, 0.8, 0.5,0.0);
uniform sampler2D gradient_tint : repeat_enable;
uniform sampler2D heart_mask : repeat_enable;

group_uniforms Vertex_unis;
uniform float sway_strength = 1.2;
uniform float sway_phase_len = 1.2;
uniform float sway_speed = 1.2;

void vertex() {
	vec4 mask = texture(heart_mask, UV);
	float strength = mask.a * sway_strength;
	VERTEX.x += sin(VERTEX.x * sway_phase_len * 1.123 + TIME * sway_speed) * strength * mask.a;
	VERTEX.y += cos(VERTEX.y * sway_phase_len + TIME * sway_speed * 1.12412) * strength * mask.a ;
	
}


void fragment() {
	float modded_y = smoothstep(1.0, UV.y+6., 6.39);
	float base_y = UV.y;
	//base_y = smoothstep(1., base_y*.6, debug);
	
	
	vec2 scroll_uv = vec2(UV.x + TIME * aurora_scroll_speed, base_y);
	vec4 result = texture(TEXTURE, scroll_uv);
	
	//the sin is optional causes there to be more "play" of the colors
	//vec4 base_color = texture(gradient_base, vec2(scroll_uv.x + (TIME * color_scroll_speed)+.2, UV.y));
	//float modded_y = smoothstep(scroll_uv.y*debug, 1.0, UV.y);
	vec4 base_color = texture(gradient_base, vec2(scroll_uv.x, modded_y - TIME*.01));
	//we subtract TIME to make the transparency mask move in the opposite direction of the aurora, looks more funky imo :3
	//also we do UV.y -.01 to get rid of a ugly 1 px wide line that would appear else wise OTL
	vec4 curve = texture(lower_transparency_mask, vec2(UV.x * curve_horizontal_repition - TIME * .3 * (sin(TIME *.0002)), UV.y -.01 ));// *(sin(TIME *.2)*-3.5+3.5) ));
	
	//applies the transparency of our mask texture to avoid a hard lower cutoff
	//result.a *= mix(result.a, 0., curve.a);
	//add stronger luminance to the base of the aurora 
	result.rgb *= mix(result.rgb, result.rgb*base_white_size, curve.a);
	
	//more transparency mixing to create a more "organic" looking result
	result.a *= mix(0., 2., result.r);
	//result.a *= mix(0, 1., UV.y);
	
	//more funky color magic, remove/edit as needed 
	result.rgb *= mix(result.rgb, base_color.rgb, UV.y );
	result.rgb *= mix(result.rgb, result.rgb*glow_strength,UV.y);
	result.rgb *= mix(result.rgb, result.rgb*glow_strength, curve.a);
	//gives it an overall richer color
	vec4 gradient_color = texture(gradient_tint,  vec2(UV.x + TIME * .2, UV.y));
	result.rgb *= gradient_color.rgb;
	
	COLOR = result;
	
	vec2 uvs = UV;
	uvs.y = mix(0., 1., UV.y+debug);
	
	//COLOR = texture(heart_mask, UV);
}
