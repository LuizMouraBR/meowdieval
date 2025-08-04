shader_type spatial;
render_mode blend_add, shadows_disabled, unshaded;

uniform vec4 color : source_color;
uniform sampler2D topbottom_gradient;
uniform sampler2D noise_1;
uniform sampler2D noise_2;
uniform sampler2D noise_3;

uniform float n1speed = 1.0;
uniform float n2speed = 2.0;
uniform float n3speed = 3.0;

uniform float skew_x_ammount = 0.0;

uniform float power = 2.0;
uniform float n2influence : hint_range(0.0, 1.0, 0.1) = 0.75;
uniform float n3influence : hint_range(0.0, 1.0, 0.1) = 0.3;

uniform vec2 UV_Multiplier = vec2(1.0, 1.0);
uniform vec2 n4size = vec2(1.0, 1.0);

void fragment() {
	vec2 base_uv = UV * UV_Multiplier;
	
	vec2 skew = vec2(skew_x_ammount * base_uv.y + skew_x_ammount * -.5, 0.0);
	base_uv += skew;
	
	ALBEDO = texture(topbottom_gradient, base_uv).rgb * power;
	ALBEDO *= color.rgb;
	ALBEDO -= texture(noise_1, base_uv + vec2(1.0, TIME * 0.1 * n1speed)).rgb;
	ALBEDO -= texture(noise_2, base_uv + vec2(1.0, TIME * 0.1 * n2speed)).rgb * n2influence;
	ALBEDO -= texture(noise_3, base_uv + vec2(1.0, TIME * 0.1 * n3speed)).rgb * n3influence;
	
	ALBEDO -= texture(noise_1, base_uv * n4size).rgb * n3influence;
	ALBEDO *= 20.0;
}
