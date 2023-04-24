class_name Camera2DTracked
extends Camera2D

const NOTIFICATION_CAMERA_UPDATED:int = 1020
func _notification(what:int):
	if(what == NOTIFICATION_CAMERA_UPDATED):
		if(!is_current()):remove_from_group(camera_group)
const camera_group:String = "camera_d2"
@export var current_extra:bool = false: set = set_current
func set_current(c:bool):
	set_current(c)
	if(c):
		add_to_group(camera_group)
		if( get_tree() ):	get_tree().get_current_scene().propagate_notification(NOTIFICATION_CAMERA_UPDATED)
		else:				connect("tree_entered", Callable(self, "set_current").bind(c), CONNECT_ONE_SHOT)

#func get_position_absolute()->Vector2:
#	var res:Vector2 = Vector2()
#	res += get_position()
#	res += get_offset()
##	res += get_
#	return res
