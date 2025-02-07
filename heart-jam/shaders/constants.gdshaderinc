
float normalized_sine(){
	return  sin(TIME)*0.5+0.5;
}
/**Remaps the UV (normally from 0.0 to 1.0) to go from -1.0 to 1.0*/
vec2 normalize_uv(vec2 uv){
	return uv * 2.0 - 1.0;
}

float psuedo_rand(float x) {
	return mod(x * 2048103.0 + cos(x * 1912.0), 1.0);
}

bool vec3_greaterThan(vec3 a, vec3 b){
	return a.r >= b.r && a.g >= b.g && a.b >= b.b;
}

vec2 rotate(vec2 uv, vec2 pivot, float angle)
{
	mat2 rotation = mat2(vec2(sin(angle), -cos(angle)),
						vec2(cos(angle), sin(angle)));
	
	uv -= pivot;
	uv = uv * rotation;
	uv += pivot;
	return uv;
}

vec4 gradient_shift(vec4 sampled_color, sampler2D gradient, float speed_scale){ 
	float x = sampled_color.r - TIME * speed_scale;
	return vec4(texture(gradient, vec2(x, 0)).rgb, sampled_color.a);
}
vec4 gradient_shift_alt(float sampled_red, sampler2D gradient, float speed_scale){ 
	float x = TIME * speed_scale;
	return vec4(texture(gradient, vec2(x, 0)).rgb, sampled_red);
}

vec4 palette_swap_cycle(vec4 input, sampler2D gradient, float speed){
	return texture(gradient, vec2(input.r + speed, 0.0));
}