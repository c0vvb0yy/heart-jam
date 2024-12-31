shader_type canvas_item;

uniform sampler2D rot_mask;
uniform sampler2D shape_mask;
uniform float rotation_speed;
const float TWO_PI = 6.28318530718;

vec4 polygon(vec2 uv, float width, int sides){
	uv = uv * 2.0 - 1.0;
	float angle = atan(uv.x, uv.y);
	float radius = TWO_PI / float(sides);
	
	float dist = cos(floor(0.5 + angle / radius) * radius - angle) * length(uv);
	float poly = step(width, dist);
	float alpha = 1.0;
	if(poly >= 1.0){
		alpha = 0.0;
	}
	return vec4(vec3(poly), alpha);
}
vec2 rotate(vec2 uv, vec2 pivot, float angle){
	mat2 rotation = mat2(vec2(sin(angle), -cos(angle)),
						vec2(cos(angle), sin(angle)));
	
	uv -= pivot;
	uv = uv * rotation;
	uv += pivot;
	return uv;
}
vec2 scale(vec2 uv, float x, float y)
{
	mat2 scale = mat2(vec2(x, 0.0), vec2(0.0, y));
	
	uv -= 0.5;
	uv = uv * scale;
	uv += 0.5;
	return uv;
}

void fragment(){
	vec2 rotated_uv = rotate(UV, vec2(0.5), TIME);
	vec2 rotation_uv = rotate(UV, vec2(0.5), TIME * rotation_speed);
	float rotation = texture(rot_mask, rotation_uv).b;
	vec4 shaped = texture(shape_mask, rotated_uv);
	vec2 shaped_uvs = scale(UV, shaped.r,  shaped.r);
	vec4 result =  polygon(shaped_uvs, 0.01, 5);
	//result.a *= sin(TIME * shaped.r);
	//result.a *= rotation;
	shaped.a *= sin(TIME*shaped.r);
	//shaped.a *= rotation;
	COLOR = result;
}
