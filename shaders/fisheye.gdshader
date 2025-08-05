shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture;
uniform float amount = 0.0;

void fragment() {
	vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
	vec2 p = FRAGCOORD.xy / iResolution.x; //normalized coords with some cheat
	float prop = iResolution.x / iResolution.y;//screen proroption
	vec2 m = vec2(0.5, 0.5 / prop);//center coords
	vec2 d = p - m;//vector from center to current fragment
	float r = sqrt(dot(d, d)); // distance of pixel from center
	
	float power = ( 2.0 * 3.141592 / (2.0 * sqrt(dot(m, m))) ) * amount;

	float bind;//radius of 1:1 effect
	if (power > 0.0) {
		bind = sqrt(dot(m, m));//stick to corners
	}
	else {
		if (prop < 1.0) 
			bind = m.x; 
		else 
			bind = m.y;
	}//stick to borders

	//Weird formulas
	vec2 uv;
	if (power > 0.0)//fisheye
		uv = m + normalize(d) * tan(r * power) * bind / tan( bind * power);
	else if (power < 0.0)//antifisheye
		uv = m + normalize(d) * atan(r * -power * 10.0) * bind / atan(-power * bind * 10.0);
	else uv = p;//no effect for power = 1.0

	vec3 col = texture(screen_texture, vec2(uv.x, uv.y * prop)).xyz;
	COLOR = vec4(col, 1.0);
}