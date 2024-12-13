shader_type canvas_item;
#include "res://shaders/constants.gdshaderinc"

uniform sampler2D noise_texture : repeat_enable;
uniform float noise_scale : hint_range(0.1, 10.0) = 1.0;
uniform float distortion_scale_x : hint_range(0.0, 10.0) = 0.03;
uniform float distortion_scale_y : hint_range(0.0, 10.0) = 0.03;
uniform float rainbow_intensity : hint_range(0.0, 1.0) = 0.5;

void fragment() {
    vec4 base_texture = texture(TEXTURE, UV);

    vec2 noise_uv = UV * noise_scale ;
	noise_uv.y -= TIME*0.1;
	//noise_uv.x += sin(TIME*0.1);
	//noise_uv.x += cos(tan(sin(TIME*0.5)));
	noise_uv.x += 0.;
	noise_uv.x += tan(TIME*0.03);
    float noise_x = texture(noise_texture, noise_uv).r;
    float noise_y = texture(noise_texture, noise_uv).g;

	float distort_x = sin(tan(distortion_scale_x*TIME*0.001)*200.0) +1.2;
	float distort_y = sin(tan(distortion_scale_y*TIME*0.001)*600.0) +1.2;

    vec2 distorted_uv = UV + vec2(noise_x * distort_x, noise_y * distort_y);
    //vec2 distorted_uv = UV + vec2(noise_x * distortion_scale_x, noise_y * distortion_scale_y);

    float rainbow_r = sin(distorted_uv.x * 15.0 + TIME * 0.1);
    float rainbow_g = tan(sin(distorted_uv.y * 15.0 + TIME * 0.1 + 2.0));
    float rainbow_b = sin(tan(distorted_uv.x * 10.0 + TIME * 0.1 + 4.0));

    vec3 rainbow_color = vec3(rainbow_r, rainbow_g, rainbow_b);
    rainbow_color = (rainbow_color + 1.0) * 0.5; // Normalize to [0.0, 1.0]

    vec3 final_color = mix(base_texture.rgb, rainbow_color, rainbow_intensity);

    COLOR = vec4(final_color, COLOR.a);
}