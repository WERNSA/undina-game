shader_type canvas_item;
render_mode unshaded;

uniform float wave_speed = 3.0;   // velocidad del bucle de la onda
uniform float wave_freq = 10.0;   // frecuencia vertical de la onda
uniform float wave_width = 1.0;   // amplitud de la onda

// 💡 Declaración necesaria en Godot 4:
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
	vec2 scale_UV = SCREEN_UV;
	vec2 wave_uv_offset;
	wave_uv_offset.x = cos((TIME * wave_speed) + UV.x + UV.y * wave_freq * 2.0) * wave_width * 0.01;
	COLOR = texture(SCREEN_TEXTURE, scale_UV + wave_uv_offset);
}