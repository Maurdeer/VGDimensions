shader_type canvas_item;

uniform float brightness : hint_range(0.0, 1.0) = 0.0;
uniform float glow_intensity : hint_range(0.0, 5.0) = 2.0;

uniform vec4 glow_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
	vec4 original_color = texture(TEXTURE, UV);
	vec3 curr_brightness = glow_color.rgb * brightness * glow_intensity;
	
	COLOR.rgb = original_color.rgb + curr_brightness;
	COLOR.a = original_color.a;
}