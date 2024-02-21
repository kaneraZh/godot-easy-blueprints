class_name Analog1D
extends InputGroup

@export var positive:Analog : get=get_positive, set=set_positive
func set_positive(p:Analog):
	positive = p if (p is Analog) else Analog.new()
	positive.connect(&"just_above", Callable(self, &"emit_signal").bind(&"just_above"))
	positive.connect(&"just_below", Callable(self, &"emit_signal").bind(&"just_below"))
	positive.append_thresholds(thresholds)
	positive.set_deadzone_in(0.0)
	positive.set_deadzone_out(1.0)
func get_positive()->Analog: return positive
@export var negative : Analog: set = set_negative
func set_negative(n:Analog):
	negative = n if (n is Analog) else Analog.new()
	negative.connect(&"just_above", Callable(self, &"emit_signal").bind(&"just_below"))
	negative.connect(&"just_below", Callable(self, &"emit_signal").bind(&"just_above"))
	negative.append_thresholds(thresholds)
	negative.set_deadzone_in(0.0)
	negative.set_deadzone_out(1.0)
func get_negative()->Analog: return negative
signal just_above
signal just_below

@export var thresholds:Array[ThresholdAbs]: set = set_thresholds
func set_thresholds(t:Array):
	thresholds = t
	set_check_every_frame(!thresholds.is_empty())
func append_thresholds(t:Array[ThresholdAbs]):
	var res:Array[ThresholdAbs] = thresholds
	res.append_array(t)
	set_thresholds(res)

@export_flags(
"flip",
"t/f -> add/priority",
"on priority t/f -> +/-"
) var settings:= 0b000
func set_flip(f:int):	settings = (settings&(~(1<<0)))+((f&1)<<0)
func set_mode(f:int):	settings = (settings&(~(1<<1)))+((f&1)<<1)
func set_axis(f:int):	settings = (settings&(~(1<<2)))+((f&1)<<2)
func get_flip():	return (settings>>0)&1
func get_mode():	return (settings>>1)&1
func get_axis():	return (settings>>2)&1
@warning_ignore("shadowed_variable")
func set_settings(
	flip:bool,
	mode:bool,
	axis:bool,
	active:=true):
		set_flip(	int(flip))
		set_mode(	int(mode))
		set_axis(	int(axis))
		set_active(	active)

@export_range(0.0,1.0) var deadzone_in:float = 0.0 : set=set_deadzone_in, get=get_deadzone_in
@export_range(0.0,1.0) var deadzone_out:float= 1.0 : set=set_deadzone_out, get=get_deadzone_out
func get_deadzone_in()->float:return deadzone_in
func set_deadzone_in(dz:float)->void:
	deadzone_in = dz if (dz<deadzone_out) else deadzone_in
	if(is_instance_valid(positive)):positive.set_deadzone_in(0.0)
	if(is_instance_valid(negative)):negative.set_deadzone_in(0.0)
func get_deadzone_out()->float:return deadzone_out
func set_deadzone_out(dz:float)->void:
	deadzone_out = dz if (dz>deadzone_in) else deadzone_out
	if(is_instance_valid(positive)):positive.set_deadzone_out(1.0)
	if(is_instance_valid(negative)):negative.set_deadzone_out(1.0)

func press()->float:
	var value:float = positive.press() - negative.press()
	var priority:float
	if(get_axis()):	priority =-negative.press()
	else:			priority = positive.press()
	if(get_mode() && priority):value = priority
	return value * (((~get_flip()&1)<<1)-1) * active
