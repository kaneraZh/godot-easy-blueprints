extends Resource
class_name InputRaw

@export var action:StringName : set=set_action
func set_action(a:StringName):
	assert(InputMap.has_action(a), "<InputMap> has no action called %s"%a)
	action = a
@export_flags('On') var active:int = 1
func set_active(a:bool):active = int(a)
func get_active()->bool:return bool(active)
