extends Threshold
class_name ThresholdAbs
@export_range(0.0, 1.0) var value:float=0.0 : set=set_value
func set_value(v:float)->void:
	value = v
	value_squared = pow(value, 2.0)
func test(val:float)->int:
	var res:int = int(signf(val-value) * get_active())
	if(res != last && res != 0):
		if(		res== get_onAbove()):emit_signal(&"just_above")
		elif(	res==-get_onBelow()):emit_signal(&"just_below")
	last = res
	return res
var value_squared:float
func test_squared(val:float)->int:
#	var res:int = clampi(signf(val-value_squared), -get_onBelow(), get_onAbove()) * get_active()
	var res:int = int(signf(val-value_squared) * get_active())
#	print_debug("tested %20s-%s = %s"%[val, value_squared, signf(val-value_squared)])
	if(res != last && res != 0):
		if(res==get_onAbove()):emit_signal(&"just_above")
		elif(	get_onBelow()):emit_signal(&"just_below")
	last = res
	return res
