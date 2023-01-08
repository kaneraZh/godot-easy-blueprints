shader_type canvas_item;
render_mode unshaded;
uniform vec2 resolution;




void fragment(){
	vec2 resolution_step = 1.0/resolution;
	
	
	vec2 uv = UV*resolution;
//	while(uv.x>1.0) uv.x-=1.0;
//	while(uv.y>1.0) uv.y-=1.0;
//	while(uv.x<0.0) uv.x+=1.0;
//	while(uv.y<0.0) uv.y+=1.0;
	uv = floor(uv)*resolution_step;
	uv+= resolution_step/2.0;
	
	COLOR = textureLod(SCREEN_TEXTURE, vec2(uv.x,1.0-uv.y),0);
	COLOR*= texture(TEXTURE, UV).a;
}