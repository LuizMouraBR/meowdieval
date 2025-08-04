shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back;

uniform sampler2D noise;
uniform float cutoff : hint_range(0.0, 1.0) = 1.0;
uniform vec2 speed = vec2(0.1, 0.1);
uniform float fade_width = 0.1;
uniform vec4 color : source_color = vec4(0.0, 0.5, 0.0, 1.0);
uniform float intensity = 1.0;

void fragment() {
	vec2 base_uv = UV + TIME * speed;
	vec4 noise_tex = texture(noise, base_uv);
	ALBEDO = vec3(0.0);
	EMISSION = (noise_tex.r * color.rgb) * intensity;
	
	// Compute distance to the closest edge (0 to 1 in both UV axes)
    float edge_fade = min(UV.x, 1.0 - UV.x);
    edge_fade = min(edge_fade, min(UV.y, 1.0 - UV.y));

    // Smooth fade near the edge
    float fade = smoothstep(0.0, fade_width, edge_fade);
	
	ALPHA = (noise_tex.r - cutoff) * fade;
}

