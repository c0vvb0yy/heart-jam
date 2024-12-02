shader_type canvas_item;
#include "res://shaders/constants.gdshaderinc"

// Animate from 0 to 1
uniform float progress: hint_range(0.0, 1.0) = 0.0;
uniform float density: hint_range(0.0, 5.0) = 0.0;

// How jagged each band of melting pixels are
uniform float meltiness: hint_range(0.0, 16.0) = 1.0;

uniform sampler2D gradient: repeat_enable;
uniform float speed;

void fragment() {
	vec2 uv = UV;
	float _progress = tan(TIME * density )* progress;
	// Move pixels near the top faster
	uv.y -= _progress / UV.y ;//* psuedo_rand(UV.y);
	uv.x += _progress / UV.x ;//* (psuedo_rand(tan(normalized_sine()))) * psuedo_rand(tan(TIME));
	// Created jagged edges for each pixel on the x-axis
	uv.y -= _progress * meltiness * psuedo_rand(UV.x - mod(UV.x, TEXTURE_PIXEL_SIZE.x));
	uv.x -= _progress * meltiness * psuedo_rand(UV.y - mod(UV.y, TEXTURE_PIXEL_SIZE.y));
	vec4 input = texture(TEXTURE, uv);

	COLOR.rgb = palette_swap_cycle(texture(TEXTURE, uv), gradient, TIME * speed).rgb ;
	//COLOR = texture(TEXTURE, uv);
	// "delete" pixels out of range
	if (uv.y <= 0.0 || uv.x <= 0.0) {
		COLOR.a = 0.0;
	}
}