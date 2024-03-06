extends Resource
class_name InputMouse

@export_flags('active') var active:int=0 : set=set_active
func set_active(a:int)->void:
	if(active!=a):references_active+= 1 if a else -1
	active = a
func get_active()->bool:return bool(active)
var check_every_frame:bool = false
func set_check_every_frame(v:bool)->void:check_every_frame = v
func get_check_every_frame()->bool:return check_every_frame

@export var thresholds:Array[Threshold] : get = get_thresholds, set = set_thresholds
func set_thresholds(t:Array[Threshold]):
	for td in t:
		if(td==null): td = Threshold.new()
		td.connect(&"just_above", Callable(self, &"emit_signal").bind(&"just_above", td.value))
		td.connect(&"just_below", Callable(self, &"emit_signal").bind(&"just_below", td.value))
	thresholds = t
	set_check_every_frame(!t.is_empty())
func get_thresholds()->Array:return thresholds
func append_thresholds(t:Array[Threshold]):
	var res:Array[Threshold] = get_thresholds()
	res.append_array(t)
	set_thresholds(res)
@warning_ignore("shadowed_variable")
func set_threshold_active(id:int, active:int):
	assert(id<thresholds.size() && id>0)
	thresholds[id].set_active(active)
signal just_above
signal just_below

@export_flags(
	"visible",
	"confined",
	"captured",
	"relative"
	) var cursor_mode:int=1 : set=set_cursor_mode, get=get_cursor_mode
func get_cursor_mode()->int: return cursor_mode
func set_cursor_mode(v:int)->void:
	cursor_mode = v&0b1111
	_cursor_mode_update()
func is_visible()->int:	return (cursor_mode>>0)&1
func is_confined()->int:return (cursor_mode>>1)&1
func is_captured()->int:return (cursor_mode>>2)&1
func is_relative()->int:return (cursor_mode>>3)&1
func _cursor_mode_update()->void:
	match (cursor_mode&0b11):
		0b00: Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		0b01: Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		0b10: Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
		0b11: Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

enum CONFINED_SHAPE{
	WINDOW,
	RECTANGLE,
	CIRCLE,
}

static var references_active:int=0 : set=set_references_active
static func set_references_active(v:int)->void:
	references_active = v
	if(references_active>=1):
		push_warning("more than one reference active (%s active), there might be erratic mouse behaviour."%references_active)
static var position_current:Vector2i = Vector2i()
static var position_last:Vector2i = Vector2i()
var update_cursor:bool = true
func _update_cursor()->void:
	position_last = position_current
	position_current = DisplayServer.mouse_get_position()
	if(is_captured()):DisplayServer.warp_mouse( (DisplayServer.window_get_size()/2) )
	update_cursor = true
func press()->Vector2i:
	if(update_cursor):
		RenderingServer.connect(&"frame_post_draw", _update_cursor, CONNECT_ONE_SHOT)
		update_cursor = false
	var res:Vector2i = position_current*active
	if( is_relative() ):
		if( is_captured() ):
			res-= (DisplayServer.window_get_size()/2)+DisplayServer.window_get_position()
		else:
			res-= position_last
	for t in thresholds:
		if(t.get_active()):t.test(res)
	return res
