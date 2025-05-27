shader_type canvas_item;

uniform float glitch_mode = 0.5; // 0.0 = stable, 1.0 = nonstop spaz glitch
uniform float glitch_level = 0.5;
uniform float block_size_y = 0.05;
uniform float block_size_x = 0.1;

float rand(float x) {
    return fract(sin(x * 91.3458) * 47453.5453);
}

void fragment() {
    // Vertical strips (rows)
    float block_y = floor(UV.y / block_size_y) * block_size_y;
    float base_strength = rand(block_y * 100.0);

    // Horizontal strips (columns) for block displacement
    float block_x = floor(UV.x / block_size_x);

    // Random horizontal displacement per column block
    float col_offset = (rand(block_x * 10.0 + TIME * 5.0) - 0.5) * 0.04 * glitch_mode;

    // Determine if glitch burst is active
    float burst_trigger = fract(sin(TIME * 1.5) * 43758.5453);
    float is_burst = step(1.0 - glitch_mode, burst_trigger);

    // Add random noise inside bursts for glitch intensity
    float glitch_noise = fract(sin(TIME * 5.0 + block_y * 10.0) * 43758.5453);
    float burst = is_burst * pow(glitch_noise, 1.0 - glitch_mode) * glitch_mode * 50.0 * glitch_level;

    float glitch_strength = base_strength * burst;

    // Per-row pixel shift, multiplied by glitch strength
    float shift = glitch_strength * sin(TIME * 50.0 + block_y * 200.0) * 0.03;

    // Combine column block horizontal displacement + row shift
    vec2 displaced_uv = UV + vec2(col_offset + shift, 0.0);

    // Color channel offsets for RGB glitch effect
    float r = texture(TEXTURE, displaced_uv + vec2(shift, 0.0)).r;
    float g = texture(TEXTURE, displaced_uv).g;
    float b = texture(TEXTURE, displaced_uv - vec2(shift, 0.0)).b;

    COLOR = vec4(r, g, b, 1.0);
}



//shader_type canvas_item;
//
//uniform float glitch_mode = 0.5; // 0.0 = stable, 1.0 = nonstop spaz glitch
//uniform float glitch_level = 0.5;
//uniform float block_size = 0.05;
//
//
//float rand(float x) {
    //return fract(sin(x * 91.3458) * 47453.5453);
//}
//
//void fragment() {
    //float block_y = floor(UV.y / block_size) * block_size;
//
    //float base_strength = rand(block_y * 100.0);
//
    //// Determine if we're currently in a glitch burst (based on glitch_mode)
    //float burst_trigger = fract(sin(TIME * 1.5) * 43758.5453);
    //float is_burst = step(1.0 - glitch_mode, burst_trigger);
//
    //// Add random noise inside bursts
    //float glitch_noise = fract(sin(TIME * 5.0 + block_y * 10.0) * 43758.5453);
    //float burst = is_burst * pow(glitch_noise, 1.0 - glitch_mode) * glitch_mode * 50.0 * glitch_level;
//
    //float glitch_strength = base_strength * burst;
//
    //float shift = glitch_strength * sin(TIME * 50.0 + block_y * 200.0) * 0.03;
    //vec2 offset = vec2(shift, 0.0);
//
    //float r = texture(TEXTURE, UV + offset).r;
    //float g = texture(TEXTURE, UV).g;
    //float b = texture(TEXTURE, UV - offset).b;
//
    //COLOR = vec4(r, g, b, 1.0);
//}