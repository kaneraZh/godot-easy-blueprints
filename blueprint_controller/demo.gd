extends Node2D

var con:Controller
func _ready():
	set_controller($Controller)
	pause.connect(&"just_pressed", Callable(self, &"on_pause_press"))
	pause.connect(&"just_released",Callable(self, &"on_pause_release"))

@export var pause:Binary
func on_pause_press():print("paused!")
func on_pause_release():print("unpaused!")
@export var stick:Analog2D
@export var pad:Binary2D
@export var mouse:InputMouse
var controller:Controller : set=set_controller
func set_controller(c:Controller):
	controller = c
	#controller.add_button(pause)
	#controller.add_group(stick)
	#controller.add_group(pad)
	controller.set_mouse(mouse)
	stick.connect(&"just_above", Callable(self, &"_on_stick_threshold_above"))
	stick.connect(&"just_below", Callable(self, &"_on_stick_threshold_below"))
#	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
#	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CAPTURED)
#	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CONFINED)
func _on_stick_threshold_above(theshold_value:float)->void:
	print('ABOVE %s'%theshold_value)
#	print_debug('ABOVE %s'%theshold_value)
func _on_stick_threshold_below(theshold_value:float)->void:
	print('BELOW %s'%theshold_value)
#	print_debug('BELOW %s'%theshold_value)
func _process(_delta):
#	print_debug(stick.press())
#	print(Input.mouse_get_position())
	print("mouse position: %s"%mouse.press())
	queue_redraw()

@onready var center:Vector2 = Vector2(get_window().size/2)
@onready var pos_pad:Vector2 = Vector2(center.x/2, center.y)
@onready var pos_stick:Vector2 = Vector2(center.x/2+center.x, center.y)
@onready var pos_mouse:Vector2i = Vector2i(100, 100)
func _draw():
	draw_circle(pos_pad,5,Color.SPRING_GREEN)
	draw_circle(pos_pad+(pad.press()*100),5,Color.TOMATO)
	draw_circle(pos_stick,5,Color.SPRING_GREEN)
	draw_circle(pos_stick+(stick.press()*100),5,Color.TOMATO)
	draw_circle(pos_mouse+(mouse.press()),5,Color.SPRING_GREEN)
