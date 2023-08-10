extends CharacterBody2D

@export_range(0, 500) var speed:float = 200.0
@export var target:Node2D : set=set_target
func set_target(t:Node2D):
	target = t
	_navigation_update()
var nav:NavigationAgent2D : set=set_nav
func set_nav(n:NavigationAgent2D):
	var velocity_computed:Callable = Callable(self, "_on_velocity_computed")
#	var path_changed:Callable = Callable(self, "_on_path_changed")
	if(nav):
		if(nav.is_connected("velocity_computed", velocity_computed)):nav.disconnect("velocity_computed", velocity_computed)
#		if(nav.is_connected("path_changed", path_changed)):nav.disconnect("path_changed", path_changed)
	nav = n
	nav.connect("velocity_computed", velocity_computed)
#	nav.connect("path_changed", path_changed)
	_navigation_update()
#func _on_path_changed():

func _ready():
	set_nav($NavigationAgent2D)

func _navigation_update():
	if(nav && target):
		nav.call_deferred("set_target_position",target.get_position())

func _physics_process(_delta):
	if(nav.is_navigation_finished()):return
	var pos:Vector2 = nav.get_next_path_position()-get_position()
	nav.set_velocity(pos.normalized()*speed)
func _on_velocity_computed(vel:Vector2):
#	_navigation_update()
	set_velocity(vel)
	move_and_slide()


#
#@onready var nav:NavigationAgent2D = $NavigationAgent2D
#
#signal target_set
#func _unhandled_input(event:InputEvent):
#	if(event is InputEventMouseButton && event.is_pressed()): nav.set_target_position(event.get_position())
#
#func arrived(location:Vector2, tolerance:float)->bool:
#	return get_position().distance_squared_to(location)<=pow(tolerance,2.0)
#
#func _ready():
#	nav.connect("velocity_computed", Callable(self, "move"))
#
#@export var speed:float	= 100.0: get = get_speed, set = set_speed
#@onready var speed_squared:float = pow(speed,2.0)*2
#func set_speed(s:float):
#	speed = s
#	speed_squared = pow(speed, 2.0)*2
#	if(!nav):connect("ready", Callable(self, "set_speed").bind(s), CONNECT_ONE_SHOT+CONNECT_DEFERRED)
#	else:
#		nav.set_max_speed(speed_squared)
#		var distance:float = ceil(speed*0.016667)
#		nav.set_path_desired_distance(distance)
#		nav.set_target_desired_distance(distance)
#		nav.set_path_max_distance(distance+2)
#func get_speed()->float:
#	return speed
#func _draw():draw_circle(nav.get_next_path_position()-get_position(), 3.0, Color.AQUA)
#
#func _physics_process(delta:float):
#	if(!nav.is_target_reached()):
#		var mov:Vector2 = nav.get_next_path_position()-get_position()
#		mov = Vector2(	0.0 if (abs(mov.x)<=nav.get_path_desired_distance()-.5) else sign(mov.x) ,
#						0.0 if (abs(mov.y)<=nav.get_path_desired_distance()-.5) else sign(mov.y) )
#		nav.set_speed(mov*speed)
#func move(mov:Vector2):
#	if(mov.length_squared() < speed_squared):
#		if(abs(mov.x)>abs(mov.y)):	mov = Vector2(sign(mov.x),0.0)
#		else:						mov = Vector2(0.0,sign(mov.y))
#	else: mov = mov.sign()
#	set_velocity(mov*speed)
#	move_and_slide()
#	queue_redraw()
