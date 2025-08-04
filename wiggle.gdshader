shader_type spatial;
render_mode cull_disabled;

uniform float sway_strength : hint_range(0.0, 1.0) = 0.2;
uniform float sway_speed : hint_range(0.1, 10.0) = 2.0;
uniform float sway_scale : hint_range(0.1, 10.0) = 1.0;

void vertex() {
    // Create some pseudo-random variation per instance
    float sway_phase = sin(VERTEX.x * 0.1 + VERTEX.z * 0.1);
    
    // World position based sway
    float sway = sin(TIME * sway_speed + (VERTEX.x + VERTEX.z) * sway_scale + sway_phase);

    // Apply sway only above ground (e.g., don't move the base of the grass)
    float height_factor = clamp(VERTEX.y, 0.0, 1.0);

    VERTEX.x += sway * sway_strength * height_factor;
}
