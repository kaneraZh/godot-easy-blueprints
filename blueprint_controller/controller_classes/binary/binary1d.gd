class_name Binary1D
extends InputGroup

@export var positive:Binary: get = get_positive, set = set_positive
func set_positive(p:Binary):
	positive = p# if (p is Binary) else Binary.new()
	positive.setup(get_on_release(),get_on_press(),get_active())
	positive.connect(&"just_pressed", Callable(self, &"emit_signal").bind(&"just_pressed"))
	positive.connect(&"just_released", Callable(self, &"emit_signal").bind(&"just_released"))
func get_positive()->Binary: return positive
@export var negative:Binary: get = get_negative, set = set_negative
func set_negative(n:Binary):
	negative = n# if (n is Binary) else Binary.new()
	negative.setup(get_on_release(),get_on_press(),get_active())
	negative.connect(&"just_pressed", Callable(self, &"emit_signal").bind(&"just_pressed"))
	negative.connect(&"just_released", Callable(self, &"emit_signal").bind(&"just_released"))
func get_negative()->Binary: return negative
signal just_released
signal just_pressed

@export_flags(
	"flip",
	"t/f -> add/priority",
	"on priority t/f -> +/-"
		) var settings := 0b000
func set_flip(f:int):settings = (settings&(~(1<<0)))+((f&1)<<0)
func set_mode(f:int):settings = (settings&(~(1<<1)))+((f&1)<<1)
func set_axis(f:int):settings = (settings&(~(1<<2)))+((f&1)<<2)
func get_flip()->int:return (settings>>0)&1
func get_mode()->int:return (settings>>1)&1
func get_axis()->int:return (settings>>2)&1
@warning_ignore("shadowed_variable")
func set_settings(
	flip:bool,
	mode:bool,
	axis:bool,
	active:=true):
		set_flip(	int(flip))
		set_mode(	int(mode))
		set_axis(	int(axis))
		set_active(active)

@export_flags(
	"on release",
	"on press"
		) var signals := 0
func set_on_release(f:bool):
	signals = (signals&(~(1<<0)))+((int(f)&1)<<0)
	set_check_every_frame(f)
func set_on_press(f:bool):
	signals = (signals&(~(1<<1)))+((int(f)&1)<<1)
	set_check_every_frame(f)
func get_on_release():	return (signals>>0)&1
func get_on_press():	return (signals>>1)&1
func set_flags(
	on_release:bool,
	on_press:bool):
		set_on_press(on_press)
		set_on_release(on_release)

func press()->float:
	var value:float = positive.press() - negative.press()
	var priority:float
	if(get_axis()):	priority =-negative.press()
	else:			priority = positive.press()
	if(get_mode() && priority):value = priority
	return value * (((~get_flip()&1)<<1)-1) * active
