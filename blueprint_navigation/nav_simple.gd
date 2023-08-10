extends CharacterBody2D

@export_range(0, 500) var speed:float = 200.0
@export var target:Node2D : set=set_target
func set_target(t:Node2D):
	target = t
	navigation_update()
var nav:NavigationAgent2D : set=set_nav
func set_nav(n:NavigationAgent2D):
	nav = n
	navigation_update()

func _ready():
	set_nav($NavigationAgent2D)

func navigation_update():
	if(nav && target):
		nav.call_deferred("set_target_position",target.get_position())

func _physics_process(_delta):
	if(nav.is_navigation_finished()):return
	var pos:Vector2 = nav.get_next_path_position()-get_position()
	set_velocity(pos.normalized()*speed)
	move_and_slide()
