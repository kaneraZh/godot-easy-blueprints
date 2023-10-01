extends Resource
class_name InputRaw

@export var action:StringName : set=set_action
func set_action(a:StringName):
	assert(InputMap.has_action(a), "<InputMap> has no action called %s"%a)
	action = a
@export_flags('active') var active:int = 1
func set_active(a:bool):active = int(a)
func get_active()->bool:return bool(active)
var check_every_frame:bool = false
func set_check_every_frame(v:bool)->void:check_every_frame = v
func get_check_every_frame()->bool:return check_every_frame
