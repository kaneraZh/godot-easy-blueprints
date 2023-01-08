tool
class_name MultipassSprite
extends Sprite
export (Array, Material) var materials setget set_materials
func set_materials(m:Array):
	for mat in m:
		if(	mat is ParticlesMaterial||
			mat is SpatialMaterial	):
				mat = null
	materials = m

var buffers:Array = []
func update_buffers(rect:Rect2 = get_view_rect()):
	for b in buffers:
		b.set_rect(rect)
var sprites:Array = []
func update_sprites_rect(rect:Rect2	= get_view_rect()):
	for s in sprites:
		var mat:Material = s.get_material()
		mat.set_shader_param("RECT_START",	rect.position)
		mat.set_shader_param("RECT_SIZE",	rect.size)
		mat.set_shader_param("RECT_END",	rect.end)
		mat.set_shader_param("SCREEN_RESOLUTION", get_viewport_rect().size)
func update_sprites_uv(rect:Rect2	= get_view_uv()):
	for s in sprites:
		var mat:Material = s.get_material()
		mat.set_shader_param("UV_START",rect.position)
		mat.set_shader_param("UV_SIZE",	rect.size)
		mat.set_shader_param("UV_END",	rect.end)

func update_rects():
	var rect:Rect2 = get_view_rect()
	update_buffers(rect)
	update_sprites_rect(rect)
	updated_last = "rects"
func update_uvs():
	update_buffers()
	update_sprites_uv()
	updated_last = "uvs"

var updated_last:String
#func update_last():
#	call("update_%s"%updated_last)

const NOTIFICATION_CAMERA_UPDATED:int = 1020
func _notification(what:int):
	if(what == NOTIFICATION_CAMERA_UPDATED):
			call_deferred("update_%s"%updated_last)
			print("notified!! :p")

func get_view_size()->Vector2:
	return get_texture().get_size()*get_scale()*get_viewport_transform().get_scale()
const camera_group:String = "camera_d2"
func get_view_position()->Vector2:
	var size:Vector2= get_view_size()/2.0
	var pos:Vector2	= get_position()+get_offset()
	if(get_tree().has_group(camera_group)):
		var camera:Camera2DTracked = get_tree().get_nodes_in_group(camera_group).front()
		pos -= camera.get_position()
		if(camera.get_anchor_mode()):
			pos+= get_viewport_transform().get_scale()/2
		size*= camera.get_scale()
	if(!is_centered()):
		pos+= get_view_size()/2.0
	return Vector2(	+pos.x-size.x,
					-pos.y-size.y+get_viewport_rect().size.y)
func get_view_rect()->Rect2:
	return Rect2(get_view_position(), get_view_size())
func get_view_uv()->Rect2:
	var size:Vector2 = get_viewport_rect().size
	return Rect2(get_view_position()/size, get_view_size()/size)

func _enter_tree():
	if(Engine.is_editor_hint()):return
	var bbc:BackBufferCopy = BackBufferCopy.new()
	bbc.set_copy_mode(BackBufferCopy.COPY_MODE_RECT)
	for m in materials:
		var b:BackBufferCopy= bbc.duplicate(BackBufferCopy.DUPLICATE_USE_INSTANCING)
		var s:Sprite		= Sprite.new()
		s.set_texture(texture)
		s.set_material(m)
		s.set_light_mask(0)
		add_child(b)
		add_child(s)
		buffers.append(b)
		sprites.append(s)
	#if(materials.size()&1):set_flip_v(!is_flipped_v())
	set_offset(get_offset())
	set_centered(is_centered())
	set_position(get_position())

func set_texture(t:Texture):
	texture = t
	update_rects()
func set_offset(o:Vector2):
	offset = o
	for s in sprites:
		s.set_offset(o)
	update_rects()
func set_centered(c:bool):
	centered = c
	for s in sprites:
		s.set_centered(c)
	update_rects()
func set_position(p:Vector2):
	position = p
	update_rects()

const timer:float = 1.0
var clock:float = 0.1
var time:float = 0.0
const sp:float = 1000000.0
export var init_position:Vector2
export var circle:bool = true setget set_circle
func set_circle(b:bool):
	circle = b
	if(b):init_position = get_position()
	notification(EditorSettings.NOTIFICATION_EDITOR_SETTINGS_CHANGED)
func _process(delta):
	if(circle):
		var p := Time.get_ticks_usec()/sp
		set_position( init_position+Vector2(cos(p),sin(p)*3.0)*100.0 )
	clock-= delta
	if(clock < 0.0 && !Engine.is_editor_hint()):
		clock = timer
		
#		print('cam trans: %s'%get_viewport().get_camera().get_camera_transform())
