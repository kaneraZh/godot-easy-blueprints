class_name Analog
extends InputRaw

@export var thresholds:Array[ThresholdAbs] : get = get_thresholds, set = set_thresholds
func set_thresholds(t:Array[ThresholdAbs]):
	for i in t.size():
		if(t[i]==null): t[i] = ThresholdAbs.new()
		t[i].connect("just_above", Callable(self, "emit_signal").bind("just_above", t[i].value))
		t[i].connect("just_below", Callable(self, "emit_signal").bind("just_below", t[i].value))
	thresholds = t
func get_thresholds()->Array:return thresholds
func append_thresholds(t:Array[ThresholdAbs]):
	var res:Array[ThresholdAbs] = get_thresholds()
	res.append_array(t)
	set_thresholds(res)
func set_threshold_active(id:int, active:int):
	assert(id<thresholds.size() && id>0)
	thresholds[id].set_active(active)
signal just_above
signal just_below

@export_range(0.0,1.0) var deadzone_in:float = 0.0 : set=set_deadzone_in
@export_range(0.0,1.0) var deadzone_out:float= 1.0 : set=set_deadzone_out
func set_deadzone_in(dz:float)->void: deadzone_in = dz if (dz<deadzone_out)else deadzone_in
func set_deadzone_out(dz:float)->void:deadzone_out= dz if (dz>deadzone_in) else deadzone_out
var last = 0.0
func press()->float:
	var res:float = ( clamp(Input.get_action_strength(action)-deadzone_in, 0.0, deadzone_out) / deadzone_out) * active
	if(res==last): return res
	for t in thresholds:
		if(t.get_active()):t.test(res)
	last = res
	return res
