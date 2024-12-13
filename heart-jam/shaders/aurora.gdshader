shader_type canvas_item;
#include "res://shaders/constants.gdshaderinc"

uniform float height : hint_range(0.0, 10.0, 0.01);
uniform sampler2D noise :repeat_enable;
uniform sampler2D color :repeat_enable;
uniform sampler2D curve_tex :repeat_enable;
uniform float debug: hint_range(0.0, 1.0, 0.0001);
uniform vec4 col: source_color;
uniform vec4[4] shades : source_color;
void vertex() {
	// Called for every vertex the material is visible on.
}

vec4 square(vec2 _uv, vec3 tint){
	vec2 uv = _uv *2.0 - 1.0; //makes 0,0 be in middle
	vec2 abs_uv = abs(uv); 
	//float square = step(abs_uv.y,  width);
	//float square = step(width, abs_uv.y);
	float square = 0.;
	//square -= 1.;
	float alpha = texture(color, uv).a * 1.2;
	vec4 curve = texture(curve_tex, uv);
	vec3 col_square = vec3(square) + tint;
	
	float noise_alpha = texture(noise, vec2(uv.x + sin(TIME*0.5)*0.5, uv.y + sin(TIME*0.5)*0.5)).r;
	if(uv.y >= sin(height * noise_alpha)){
		alpha *= 0.0;
	}
	
	return vec4(vec3(square), alpha);
}

vec4 first_attempt(vec2 tex_uvs){
	vec2 uv = tex_uvs + vec2(0.06);
	uv.x += 0.5;
	vec4 curve_texture = texture(curve_tex, tex_uvs + TIME*.2);
	vec4 curve_texture_slighty_off = texture(curve_tex, vec2(tex_uvs.x +0.3 -TIME*.2, tex_uvs.y));
	vec4 tex = texture(color, tex_uvs + tan(cos(TIME*4.3)*.2)*sin(TIME));
	vec4 sec_tex = texture(color, vec2(uv.x, uv.y));
	float noise_alpha = texture(noise, vec2(tex_uvs.x + sin(TIME*0.5)*0.5, tex_uvs.y + sin(TIME*0.5)*0.5)).r;
	//tex.a *= noise_alpha;
	if(uv.y <= sin(height * noise_alpha ) + 0.2){
		sec_tex.a *= 0.5;
	}if(tex_uvs.y <= sin(height * noise_alpha)){
		tex.a *= 0.0;
	}
	if(tex_uvs.y >= curve_texture.r){
		tex.a *= 0.0;
	}
	if(uv.y >= curve_texture_slighty_off.r){
		//SAMPLE THE CURVE A SECOND TIME AND SHIFT ITS tex_uvs.X
		sec_tex.a *= 0.5;
	}
	tex *= sec_tex;
	return tex;
}

void fragment() {
	vec4 result = vec4(0., 0., 0., 1.0);
	for(float i = 0.; i <= 4.; i+= 1.){
		result += square(vec2(sin(UV.x+i+TIME*.2*i), UV.y), shades[int(i)].rgb);
		//result = smoothstep(result, square(vec2(sin(UV.x+i+TIME*.2*i), UV.y), 1., shades[int(i)].rgb), vec4(0.28));
		if(vec3_greaterThan(result.rgb, vec3(debug))){
			result.a *= 0.;
		}
		//result.rgb *= shades[int(i)].rgb;
	}
	COLOR = result;
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
