extends Threshold
class_name ThresholdCircle
@export_range(0.0, 1.0) var radious:float=0.0 : set=set_radious
var radious_squared:float = 0.0
func set_radious(v:float)->void:
	radious = v
	radious_squared = pow(radious, 2.0)
func test(axis:Vector2)->int:
	return _process_result( signi(axis.length_squared()-radious_squared) )
