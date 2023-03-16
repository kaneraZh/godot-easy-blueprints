extends KinematicBody2D

onready var nav:NavigationAgent2D = $NavigationAgent2D
var path:PoolVector2Array
func _unhandled_input(event:InputEvent):
	if(event is InputEventMouseButton	&&
		event.is_pressed()				):
			var ori:Vector2 = get_position()
			var tar:Vector2 = event.get_position()
			path = Navigation2DServer.map_get_path(nav.get_navigation_map(), ori, tar, false)
			update()
			print(path)

func _draw():
	for i in path.size()-1:
		draw_line(
			path[i]		- get_position(), 
			path[i+1]	- get_position(), 
			Color.blue
			)



func _physics_process(delta:float):
	if(path):
		move_and_slide()
