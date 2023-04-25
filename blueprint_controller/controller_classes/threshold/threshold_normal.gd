extends Threshold
class_name ThresholdNormal
@export_range(-1.0, 1.0) var value := 0.0
func test(val:float)->int:
# warning-ignore:narrowing_conversion
	var res:int = clamp(sign(val-abs(value)), -get_onBelow(), get_onAbove()) * get_active()
	if(res == 0): return 0
	if(res != last):
		if(res ==	get_onAbove() ): emit_signal("just_above")
		elif(		get_onBelow() ): emit_signal("just_below")
	last = res
	return res
