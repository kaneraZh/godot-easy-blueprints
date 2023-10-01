extends Resource
class_name InputGroup

@export var name:StringName
@export_flags('active') var active:int = 1
func set_active(a:bool):active = int(a)
func get_active()->bool:return bool(active)
var check_every_frame:bool = false
func set_check_every_frame(v:bool)->void:check_every_frame = v
func get_check_every_frame()->bool:return check_every_frame
