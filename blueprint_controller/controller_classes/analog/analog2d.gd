@tool
class_name Analog2D
extends InputGroup

@export var xAxis:Analog1D : get=get_x, set=set_x
func set_x(x:Analog1D):
	xAxis = x
	xAxis.connect(&"just_above", Callable(self, &"emit_signal").bind(&"just_above_x"))
	xAxis.connect(&"just_below", Callable(self, &"emit_signal").bind(&"just_below_x"))
	xAxis.append_thresholds(thresholds.duplicate())
	xAxis.set_deadzone_in(0.0)
	xAxis.set_deadzone_out(1.0)
func get_x()->Analog1D: return xAxis
@export var yAxis:Analog1D : get=get_y, set=set_y
func set_y(y:Analog1D):
	yAxis = y
	yAxis.connect(&"just_above", Callable(self, &"emit_signal").bind(&"just_above_y"))
	yAxis.connect(&"just_below", Callable(self, &"emit_signal").bind(&"just_below_y"))
	yAxis.append_thresholds(thresholds.duplicate())
	yAxis.set_deadzone_in(0.0)
	yAxis.set_deadzone_out(1.0)
func get_y()->Analog1D: return yAxis
signal just_above_x
signal just_below_x
signal just_above_y
signal just_below_y
signal just_above
signal just_below

@export var thresholds:Array[ThresholdAbs] = []: set = set_thresholds
func set_thresholds(th:Array):
	thresholds = th
	set_check_every_frame(!thresholds.is_empty())
	for t in thresholds:
		t.connect(&"just_above", Callable(self, &"emit_signal").bindv([&"just_above", t.value]))
		t.connect(&"just_below", Callable(self, &"emit_signal").bindv([&"just_below", t.value]))

@export_range(0.0,1.0) var deadzone_in:float = 0.0 : set=set_deadzone_in, get=get_deadzone_in
@export_range(0.0,1.0) var deadzone_out:float= 1.0 : set=set_deadzone_out, get=get_deadzone_out
func get_deadzone_in()->float:return deadzone_in
func get_deadzone_out()->float:return deadzone_out
func set_deadzone_in(dz:float)->void:
	deadzone_in = dz if (dz<deadzone_out) else deadzone_in
	if(is_instance_valid(xAxis)):xAxis.set_deadzone_in(0.0)
	if(is_instance_valid(yAxis)):yAxis.set_deadzone_in(0.0)
func set_deadzone_out(dz:float)->void:
	deadzone_out = dz if (dz>deadzone_in) else deadzone_out
	if(is_instance_valid(xAxis)):xAxis.set_deadzone_out(1.0)
	if(is_instance_valid(yAxis)):yAxis.set_deadzone_out(1.0)

func press()->Vector2:
	var res:Vector2 = Vector2(xAxis.press(), yAxis.press()) * active
#	clamp(Input.get_action_strength(action)-deadzone_in, 0.0, deadzone_out) / deadzone_out)
	var magnitude:float = clampf(res.length()-deadzone_in, 0.0, deadzone_out) / deadzone_out
	for t in thresholds:
#		t.test_squared(res.length_squared())
		t.test(magnitude)
	return res
