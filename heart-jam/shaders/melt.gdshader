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
	if(UV.x >= 0.61 && UV.x <= 0.84 && UV.y >= 0.45){
		if(UV.x >= 0.63 && UV.x <= 0.66 
		|| UV.x >= 0.7 && UV.x <= 0.71 
		|| UV.x >= 0.73 && UV.x <= 0.77
		|| UV.x >= 0.775 && UV.x <= 0.79
		|| UV.x >= 0.81 && UV.x <= 0.83){
			COLOR = texture(TEXTURE, UV);
			
		} else {
	vec2 uv = UV;
	float _progress = TIME * tan(density * tan(progress));
	// Move pixels near the top faster
	uv.y -= _progress / UV.y * psuedo_rand(UV.y);
	uv.x += _progress / UV.x ;//* (psuedo_rand(tan(normalized_sine()))) * psuedo_rand(tan(TIME));
	// Created jagged edges for each pixel on the x-axis
	uv.y -= _progress * meltiness * psuedo_rand(UV.x - mod(UV.x, TEXTURE_PIXEL_SIZE.x)) ;
	uv.x -= _progress * meltiness * psuedo_rand(UV.y - mod(UV.y, TEXTURE_PIXEL_SIZE.y));
	vec4 input = texture(TEXTURE, uv);
	if(COLOR.r >= 0.9 && COLOR.g >= 0.9 && COLOR.b >= 0.9){
		//COLOR.rgb = palette_swap_cycle(texture(TEXTURE, uv), gradient, TIME * speed).rgb ;
		COLOR.rgb =input.rgb ;
		//if (uv.y <= 0.0 || uv.x <= 0.0) {
		//	COLOR.a = 0.0;
		//}
	}
	}
	//COLOR = texture(TEXTURE, uv);
	// "delete" pixels out of range
}
}