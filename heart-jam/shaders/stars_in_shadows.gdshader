shader_type canvas_item;
#include "constants.gdshaderinc"

uniform sampler2D screen_texture:hint_screen_texture,repeat_disable,filter_nearest;
uniform float startstars :hint_range(0.0, 1.0, 0.1) = 0.5; //minimum brightness from which stars fade in
uniform float brightnessmax = 0.8; //until which point the stars fade in, after which they’re 100% visible
uniform sampler2D starmap:repeat_enable; //import star texture image

uniform float speed :hint_range(0.0, 1.0, 0.01) = 0.02; //star movement speed
uniform float scale :hint_range(0.0, 1.0, 0.1) = 1.; //star texture scale
uniform float intensity :hint_range(-1.0, 2.0, 0.1) = 2.; //star brightness

uniform float dot_debug_r :hint_range(0.0, 1.0, 0.001) = 0.299;
uniform float dot_debug_g :hint_range(0.0, 1.0, 0.001) = 0.587;
uniform float dot_debug_b :hint_range(0.0, 1.0, 0.001) = 0.114;
uniform float debug:hint_range(0.0, 1.0, 0.1);
uniform vec4 star_color:source_color;

void fragment() {
    vec4 color = texture(screen_texture,SCREEN_UV);
    float grayscale_value = dot(color.rgb, vec3(dot_debug_r, dot_debug_g, dot_debug_b));

    vec2 screenpos = SCREEN_UV/SCREEN_PIXEL_SIZE * SCREEN_PIXEL_SIZE.y /(scale);
	//screenpos += rotate(SCREEN_UV, screenpos, TIME * speed);
	screenpos += SCREEN_UV + vec2(cos(TIME), sin(TIME)) * 0.2;
    float effectfactor = clamp( (  (1.0-grayscale_value-startstars) * (1.0/(brightnessmax-startstars))  ), 0.,1. ); //get opacity at which stars overlay
    vec4 stars = texture(starmap, screenpos);
	//stars.rgb *= star_color.rgb;
	color.rgb += intensity * vec3(stars.a) * effectfactor ; //overlay stars
	if(stars.a <= 0.0){
		color.rgb *= star_color.rgb;
	}
//    Apply color
    COLOR = color;
	//COLOR.rgb = vec3(grayscale_value);
}