extends Resource
class_name InputMouse

@export_flags('active') var active:int = 2
func set_active(a:bool):
	if(active!=int(a)):references_active+= 1 if a else -1
	active = int(a)
func get_active()->bool:return bool(active)
var check_every_frame:bool = false
func set_check_every_frame(v:bool)->void:check_every_frame = v
func get_check_every_frame()->bool:return check_every_frame

@export var thresholds:Array[ThresholdAbs] : get = get_thresholds, set = set_thresholds
func set_thresholds(t:Array[ThresholdAbs]):
	for td in t:
		if(td==null): td = ThresholdAbs.new()
		td.connect(&"just_above", Callable(self, &"emit_signal").bind(&"just_above", td.value))
		td.connect(&"just_below", Callable(self, &"emit_signal").bind(&"just_below", td.value))
	thresholds = t
	set_check_every_frame(!t.is_empty())
func get_thresholds()->Array:return thresholds
func append_thresholds(t:Array[ThresholdAbs]):
	var res:Array[ThresholdAbs] = get_thresholds()
	res.append_array(t)
	set_thresholds(res)
@warning_ignore("shadowed_variable")
func set_threshold_active(id:int, active:int):
	assert(id<thresholds.size() && id>0)
	thresholds[id].set_active(active)
signal just_above
signal just_below

#@export var radious_in_pixels:int=0 : set=set_radious_in_pixels
#var radious_squared:int
#func set_radious_in_pixels(v:int)->void:
#	radious_in_pixels = absi(v)
#	radious_squared = radious_in_pixels**2
@export_flags(
	'visible'
	) var cursor_visible:int=1 : set=set_cursor_visible, get=get_cursor_visible
func get_cursor_visible()->int:return cursor_visible
func set_cursor_visible(v:int)->void:
	cursor_visible = v
	Input.set_mouse_mode(cursor_visible)
@export var cursor_mobility:Input.MouseMode=Input.MOUSE_MODE_VISIBLE : set=set_cursor_mobility, get=get_cursor_mobility
func get_cursor_mobility()->Input.MouseMode:return cursor_mobility
func set_cursor_mobility(v:Input.MouseMode)->void:
	cursor_mobility = v
	Input.set_mouse_mode(v)

static var references_active = 0
static var references_count = 0
static var press_position:Vector2i = Vector2i()
var last:Vector2i = Vector2i()
func press()->Vector2i:
	if(references_count<=0): press_position = DisplayServer.mouse_get_position()
	var res:Vector2i = press_position
	DisplayServer.warp_mouse( DisplayServer.screen_get_position() + DisplayServer.screen_get_size()/2 )
#	var res:float = (clamp(Input.get_action_strength(action)-deadzone_in, 0.0, deadzone_out) / deadzone_out) * active
	res = res*active
	if(res==last): return res
#	for t in thresholds:
#		if(t.get_active()):t.test(res)
	last = res
	return res
