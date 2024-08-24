shader_type canvas_item;

uniform float progress : hint_range(.99, 1.0, 0.001) = 1.0;
uniform float time_scale : hint_range(0.0, 100.0, 0.1) = 1.0;
uniform float radiation: hint_range(0.0, 1.0, 0.1) = 1.0;

float random_coord(vec2 co) {
	float time_int;
	time_int = ceil(TIME * time_scale) - radiation;
    return fract(sin(dot(co.xy, vec2(12.9898,96.233) + sin(time_int))) * 162465.4453);
}

void fragment() {
	vec2 texture_resolution = 1.0 / (TEXTURE_PIXEL_SIZE / 4.0);
	vec2 pixel_within_texture = floor(UV * texture_resolution - texture_resolution / 2.0);
	COLOR.a = radiation;
	if (progress > random_coord(pixel_within_texture)) {
		COLOR = vec4(0.0, 0.0, 0.0, 0.0);
	}
}