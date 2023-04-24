@tool
class_name Binary1D
extends X509Certificate

@export var name:= ""

@export var positive:X509Certificate: get = get_positive, set = set_positive
func set_positive(pos:X509Certificate):
	if!(pos is Binary):
		pos = Binary.new()
	positive = pos
	positive.setup(get_onRelease(),get_onPress(),get_active())
# warning-ignore:return_value_discarded
	positive.connect("just_pressed", Callable(self, "emit_signal").bind("just_pressed"))
# warning-ignore:return_value_discarded
	positive.connect("just_released", Callable(self, "emit_signal").bind("just_released"))
func get_positive()->X509Certificate: return positive
@export var negative:X509Certificate: get = get_negative, set = set_negative
func set_negative(neg:X509Certificate):
	if!(neg is Binary):
		neg = Binary.new()
	negative = neg
	negative.setup(get_onRelease(),get_onPress(),get_active())
# warning-ignore:return_value_discarded
	negative.connect("just_pressed", Callable(self, "emit_signal").bind("just_pressed"))
# warning-ignore:return_value_discarded
	negative.connect("just_released", Callable(self, "emit_signal").bind("just_released"))
func get_negative()->X509Certificate: return negative
# warning-ignore:unused_signal
signal just_released
# warning-ignore:unused_signal
signal just_pressed

@export (int, FLAGS,
	"active",
	"flip",
	"mode(add/prior)",
	"prioritySign(+/-)"
) var settings	:= 0b0001
func set_active(f:int):	settings = (settings&(~(1<<0)))+((f&1)<<0)
func set_flip(f:int):	settings = (settings&(~(1<<1)))+((f&1)<<1)
func set_mode(f:int):	settings = (settings&(~(1<<2)))+((f&1)<<2)
func set_axis(f:int):	settings = (settings&(~(1<<3)))+((f&1)<<3)
func get_active():	return (settings>>0)&1
func get_flip():	return (settings>>1)&1
func get_mode():	return (settings>>2)&1
func get_axis():	return (settings>>3)&1
func set_settings(
	flip:bool,
	mode:bool,
	axis:bool,
	active:=true):
		set_flip(	int(flip))
		set_mode(	int(mode))
		set_axis(	int(axis))
		set_active(	int(active))

@export (int, FLAGS,
	"onRelease",
	"onPress"
) var signals	:= 0
func set_onRelease(f:int):	signals = (signals&(~(1<<0)))+((f&1)<<0)
func set_onPress(f:int):	signals = (signals&(~(1<<1)))+((f&1)<<1)
func get_onRelease():	return (signals>>0)&1
func get_onPress():		return (signals>>1)&1
func set_flags(
	onRelease:bool,
	onPress:bool):
		set_onRelease(	int(onRelease))
		set_onPress(	int(onPress))

func press()->float:
	var value:float = positive.press() - negative.press()
	var priority:float
	if(get_axis()):	priority =-negative.press()
	else:			priority = positive.press()
	if(get_mode() && priority):value = priority
	return value# * (((~get_flip()&1)<<1)-1) * get_active()
