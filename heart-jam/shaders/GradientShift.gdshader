shader_type canvas_item;
#include "constants.gdshaderinc"

uniform sampler2D gradient: repeat_enable, filter_nearest;
uniform float speed_scale = 1;

uniform vec4 hue: source_color = vec4(1.,1.,1.,1.);

void fragment() {
	COLOR = gradient_shift(texture(TEXTURE, UV), gradient,speed_scale);
	COLOR *= hue;
}