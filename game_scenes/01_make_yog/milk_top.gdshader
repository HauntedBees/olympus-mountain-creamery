shader_type canvas_item;

uniform float milk_speed = 0.25;

void fragment(){
	vec2 newuv = UV;
	newuv.x += TIME * milk_speed;
	vec4 c = texture(TEXTURE, newuv);
	COLOR = c;
}