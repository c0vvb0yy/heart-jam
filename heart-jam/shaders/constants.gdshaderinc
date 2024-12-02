
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

vec4 palette_swap_cycle(vec4 input, sampler2D gradient, float speed){
	return texture(gradient, vec2(input.r + speed, 0.0));
}