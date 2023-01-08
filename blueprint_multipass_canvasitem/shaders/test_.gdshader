shader_type canvas_item;
render_mode unshaded;
void fragment(){
	COLOR = texture(SCREEN_TEXTURE, SCREEN_UV)*vec4(1.0,0.5,1.0,1.0);
}
