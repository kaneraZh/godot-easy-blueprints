shader_type canvas_item;
render_mode unshaded;
uniform vec2 RECT_SIZE;
uniform vec2 RECT_START;
uniform vec2 SCREEN_RESOLUTION;
vec2 slice_rect(vec2 start, vec2 size, vec2 uv, vec2 resolution){
	start= start/resolution;
	size = size /resolution;
	vec2 end = start+size;
	uv = uv*size;
	while(uv.x>size.x)uv.x-= size.x;
	while(uv.y>size.y)uv.y-= size.y;
//	while(uv.x<0.0)uv.x+= size.x;
//	while(uv.y<0.0)uv.y+= size.y;
//	uv.y = start.y+size.y-uv.y;
	return uv+start;
}
uniform vec2 scale;
void fragment(){
//	vec2 uv = UV;
	vec2 uv = (floor(UV*scale)/scale)+(1.0/(scale*2.0));
	uv = slice_rect(RECT_START, RECT_SIZE, uv, SCREEN_RESOLUTION);
//	uv = slice_rect(vec2(0.5), vec2(1.0), uv, vec2(1.0));
	COLOR = vec4(textureLod(SCREEN_TEXTURE,uv,0).rgb,textureLod(TEXTURE,uv,0).a);
//	COLOR = vec4(uv,vec2(1.0,1.0));
}