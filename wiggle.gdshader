shader_type spatial;
render_mode cull_disabled;

uniform sampler2D noise;
uniform sampler2D grass;
uniform float noise_strength = 0.2;

void vertex() {
	float appl = texture(noise, UV * float(VERTEX_ID) * TIME / 16.0).r * noise_strength;
	VERTEX.xz = (vec4(VERTEX + appl - noise_strength, 1.0)).xz;
}

void fragment() {
	vec4 grass_tex = texture(grass, UV);
	ALBEDO = grass_tex.rgb;
	ALPHA_TEXTURE_COORDINATE = grass_tex.ga;
}
