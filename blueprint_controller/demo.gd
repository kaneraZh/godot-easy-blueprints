extends Node2D
enum CONT{PAD, STICK, PAUSE}
var con:Controller
func _ready():
	con		= $Controller
	pause	= con.button_id(CONT.PAUSE)
	pause.connect("just_pressed", Callable(self, "pause"))
	stick	= con.button_id(CONT.STICK)
	pad		= con.button_id(CONT.PAD)
	

var pause:Binary
func pause():
	print("paused!")
var stick:Analog2D
var pad:Binary2D
func _process(_delta):
#	s = stick.press()
#	p = pad.press()
#	print("")
#	print(s)
#	print(p)
	update()

#var s:Vector2
#var p:Vector2
@onready var screen := get_window().size
@onready var center := screen/2
func draw():
	draw_rect(Rect2(center+pad.press(), stick.press().abs() ),Color.AQUAMARINE)
