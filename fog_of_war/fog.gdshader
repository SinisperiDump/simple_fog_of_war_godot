shader_type canvas_item;
uniform sampler2D noise: repeat_enable;
void fragment() {
	vec4 t = texture(TEXTURE, UV);
	vec4 n = texture(noise, UV);

	t.a = 1.0 - t.r;
	t.rgb = n.rgb;
	COLOR = t;
}