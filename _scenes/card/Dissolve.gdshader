shader_type canvas_item;

// Dissolve values
uniform float dissolve_amount : hint_range(0, 1);
uniform sampler2D noise_texture;

// Glow values
uniform vec4 glow_color : source_color = vec4(1, 255, 0, 1);
uniform float glow_thickness : hint_range(0, 1) = 0.05;

void fragment() {
    float noise_value = texture(noise_texture, UV).r;
    vec4 final_color = texture(TEXTURE, UV);

    if (noise_value > dissolve_amount && noise_value < (dissolve_amount + glow_thickness) && dissolve_amount > 0.0) {
        final_color = glow_color;
    } else if (noise_value < dissolve_amount) {
        discard;
    }

    COLOR = final_color;
}