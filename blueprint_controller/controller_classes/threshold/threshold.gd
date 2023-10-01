extends Resource
class_name Threshold
@export_flags(
"active",
"onAbove",
"onBelow"
	) var settings := 0b001
func set_active(f:int):	settings = (settings&(~(1<<0)))+((f&1)<<0)
func set_onAbove(f:int):settings = (settings&(~(1<<1)))+((f&1)<<1)
func set_onBelow(f:int):settings = (settings&(~(1<<2)))+((f&1)<<2)
func get_active()->int:	return (settings>>0)&1
func get_onAbove()->int:return (settings>>1)&1
func get_onBelow()->int:return (settings>>2)&1
signal just_above
signal just_below
var last := 0
