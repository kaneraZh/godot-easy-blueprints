extends KinematicBody2D

onready var nav:NavigationAgent2D = $NavigationAgent2D

# warning-ignore:unused_signal
signal target_set
func _unhandled_input(event:InputEvent):
	if(event is InputEventMouseButton && event.is_pressed()): nav.set_target_location(event.get_position())

func arrived(location:Vector2, tolerance:float)->bool:
	return get_position().distance_squared_to(location)<=pow(tolerance,2.0)

func _ready():
# warning-ignore:return_value_discarded
	nav.connect("velocity_computed", self, "move")

export var speed:float	= 100.0 setget set_speed, get_speed
onready var speed_squared:float = pow(speed,2.0)*2
func set_speed(s:float):
	speed = s
	speed_squared = pow(speed, 2.0)*2
# warning-ignore:return_value_discarded
	if(!nav):connect("ready", self, "set_speed", [s], CONNECT_ONESHOT+CONNECT_DEFERRED)
	else:
		nav.set_max_speed(speed_squared)
		var distance:float = ceil(speed*0.016667)
		nav.set_path_desired_distance(distance)
		nav.set_target_desired_distance(distance)
		nav.set_path_max_distance(distance+2)
func get_speed()->float:
	return speed
func _draw():draw_circle(nav.get_next_location()-get_position(), 3.0, Color.aqua)


# warning-ignore:unused_argument
func _physics_process(delta:float):
	if(!nav.is_target_reached()):
		var mov:Vector2 = nav.get_next_location()-get_position()
		mov = Vector2(	0.0 if (abs(mov.x)<=nav.get_path_desired_distance()-.5) else sign(mov.x) ,
						0.0 if (abs(mov.y)<=nav.get_path_desired_distance()-.5) else sign(mov.y) )
		nav.set_velocity(mov*speed)
func move(mov:Vector2):
	if(mov.length_squared() < speed_squared):
		if(abs(mov.x)>abs(mov.y)):	mov = Vector2(sign(mov.x),0.0)
		else:						mov = Vector2(0.0,sign(mov.y))
	else: mov = mov.sign()
# warning-ignore:return_value_discarded
	move_and_slide(mov*speed)
	update()
