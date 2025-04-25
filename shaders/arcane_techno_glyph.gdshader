shader_type canvas_item;

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    // Multiply color to boost brightness into HDR range
    COLOR = tex * 5.0; // Try 2.0–10.0 depending on your glow threshold	// Place fragment code here.
}
