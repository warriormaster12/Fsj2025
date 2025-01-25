shader_type spatial;

render_mode depth_prepass_alpha;

uniform sampler2D noise_tex;
uniform vec4 bubble_color:source_color = vec4(1.0);
uniform float height_multiplier: hint_range(0.01, 10.0, 0.01) = 0.02;
uniform float noise_sample_size = 0.1;
uniform float animation_speed: hint_range(0.01, 10.0, 0.01) = 0.1;

varying float height;

float fresnel(float amount, vec3 normal, vec3 view)
{
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), amount);
}
void vertex(){
	height = texture(noise_tex, VERTEX.xz * noise_sample_size + vec2(TIME) * animation_speed).r;
	VERTEX += NORMAL * height * height_multiplier;
}

void fragment(){
	ROUGHNESS = mix(0.05, 0.1, 1.0 - height);
	SPECULAR = height;
	ALPHA = fresnel(2.5, NORMAL, VIEW);
	ALBEDO = bubble_color.rgb;
}