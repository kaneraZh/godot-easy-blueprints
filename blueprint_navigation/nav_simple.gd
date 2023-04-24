extends CharacterBody2D

@onready var nav:NavigationAgent2D = $NavigationAgent2D
var path:PackedVector2Array
# warning-ignore:unused_signal
signal target_set
func _unhandled_input(event:InputEvent):
	if(event is InputEventMouseButton && event.is_pressed()):path_make(event.get_position())
func path_make(target:Vector2):
	path = NavigationServer2D.map_get_path(nav.get_navigation_map(), get_position(), target, false)
	update()
#	print(path)
# warning-ignore:shadowed_variable
func arrived(location:Vector2, tolerance:float)->bool:return get_position().distance_squared_to(location)<=pow(tolerance,2.0)

@export var speed:float = 300.0
var tolerance = ceil(speed*0.016667)
# warning-ignore:unused_argument
func _physics_process(delta:float):
	if(path):
		if(arrived(path[0],tolerance)):path.remove(0)
		else:
			var mov:Vector2 = path[0]-get_position()
			mov = Vector2(	0.0 if (abs(mov.x)<=tolerance-.5) else sign(mov.x) ,
							0.0 if (abs(mov.y)<=tolerance-.5) else sign(mov.y) )
# warning-ignore:return_value_discarded
			set_velocity(mov*speed)
			move_and_slide()
		update()
func _draw():
	for i in path.size()-1:
		draw_line(
			path[i]		- get_position(), 
			path[i+1]	- get_position(), 
			Color.BLUE
			)
