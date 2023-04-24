shader_type canvas_item;
render_mode unshaded;
uniform vec2 offset	= vec2(0.0);
uniform vec2 stretch= vec2(1.0);
void vertex(){
	int id_quad = VERTEX_ID>>2;
	COLOR = vec4(0.0);
	if(id_quad<=8){
		COLOR = vec4(1.0);
		VERTEX *= stretch;
		VERTEX += offset;
	}
}

uniform vec4 color		: source_color;
uniform float fade_start: hint_range(0.0, 1.0, 0.02);
uniform float fade_end	: hint_range(0.0, 1.0, 0.02);
void fragment(){
	float draw = 1.0-COLOR.a;
	float alpha = smoothstep(fade_end, fade_start, UV.x);
	COLOR *=vec4(color.rgb, alpha);
	COLOR +=texture(TEXTURE, UV)*draw;
}