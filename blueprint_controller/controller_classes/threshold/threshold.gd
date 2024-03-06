extends Resource
class_name Threshold
@export_flags(
"active",
"onAbove",
"onBelow"
	) var settings := 0b001
func set_active(f:int):	settings = (settings&(~(1<<0)))+((f&1)<<0)
func set_on_above(f:int):settings = (settings&(~(1<<1)))+((f&1)<<1)
func set_on_below(f:int):settings = (settings&(~(1<<2)))+((f&1)<<2)
func get_active()->int:return (settings>>0)&1
func get_on_above()->int:return (settings>>1)&1
func get_on_below()->int:return (settings>>2)&1
signal just_above
signal just_below
var last := 0
func _process_result(value:int)->int:
	value*= get_active()
	if(value != last && value != 0):
		if(value==get_on_above()):
			emit_signal(&"just_above")
		elif(value==-get_on_below()):
			emit_signal(&"just_below")
	last = value
	return value
