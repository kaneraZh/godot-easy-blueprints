@tool
class_name Analog1D
extends X509Certificate

@export var name:= ""

@export var positive : X509Certificate: get = get_positive, set = set_positive
func set_positive(p:X509Certificate):
	if!(p is Analog): p = Analog.new()
	positive = p
# warning-ignore:return_value_discarded
	positive.connect("just_above", Callable(self, "emit_signal").bind("just_above"))
# warning-ignore:return_value_discarded
	positive.connect("just_below", Callable(self, "emit_signal").bind("just_below"))
	positive.get_thresholds().append_array(thresholds)
func get_positive()->X509Certificate: return positive
@export var negative : X509Certificate: set = set_negative
func set_negative(n:X509Certificate):
	if!(n is Analog): n = Analog.new()
	negative = n
# warning-ignore:return_value_discarded
	negative.connect("just_above", Callable(self, "emit_signal").bind("just_below"))
# warning-ignore:return_value_discarded
	negative.connect("just_below", Callable(self, "emit_signal").bind("just_above"))
	negative.get_thresholds().append_array(thresholds)
func get_negative()->X509Certificate: return negative
# warning-ignore:unused_signal
signal just_above
# warning-ignore:unused_signal
signal just_below

@export (Array, Resource) var thresholds:= []: set = set_thresholds
func set_thresholds(t:Array):
	for i in t.size():
		if!(t[i] is threshold_abs): t[i] = threshold_abs.new()
	thresholds = t

@export (int, FLAGS,
	"active",
	"flip",
	"mode(add/prior)",
	"prioritySign(+/-)"
) var settings	:= 0b0101
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

func press()->float:
	var value:float = positive.press() - negative.press()
	var priority:float
	if(get_axis()):	priority =-negative.press()
	else:			priority = positive.press()
	if(get_mode() && priority):value = priority
	return value# * (((~get_flip()&1)<<1)-1) * get_active()
