float calculate_diff(float uv, float amp, float freq, float spd){
	float diff_x = amp * sin((freq * uv) + (TIME * spd));
	return diff_x;
}

vec2 calculate_move(vec2 dir, float spd){
	vec2 move = dir * TIME*spd;
	return move;
}