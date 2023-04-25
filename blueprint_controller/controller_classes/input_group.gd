extends Resource
class_name InputGroup

@export var name:StringName
@export_flags('On') var active:int = 1
func set_active(a:bool):active = int(a)
func get_active()->bool:return bool(active)
