tool
class_name Analog
extends InputBase

export (Array, Resource) var thresholds := [] setget set_thresholds, get_thresholds
func set_thresholds(t:Array):
	for i in t.size():
		if!(t[i] is threshold_abs): t[i] = threshold_abs.new()
		t[i].connect("just_above", self, "emit_signal", ["just_above", t[i].value])
		t[i].connect("just_below", self, "emit_signal", ["just_below", t[i].value])
	thresholds = t
func get_thresholds()->Array:return thresholds
func set_threshold_active(id:int, active:int):
	assert(id<thresholds.size() && id>0)
	thresholds[id].set_active(active)
# warning-ignore:unused_signal
signal just_above
# warning-ignore:unused_signal
signal just_below
export var deadzoneIn	:= 0.0
export var deadzoneOut	:= 1.0
var last = 0.0

func press()->float:
	var res = ( clamp(Input.get_action_strength(action)-deadzoneIn, 0.0, deadzoneOut) / deadzoneOut) * get_active()
	if(res==last): return res
	for t in thresholds:
		if(t.get_active()):t.test(res)
	last = res
	return res
