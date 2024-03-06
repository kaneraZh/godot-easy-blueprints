extends Threshold
class_name ThresholdAbs
@export_range(0.0, 1.0) var value:float=0.0 : set=set_value
func set_value(v:float)->void:
	value = v
	value_squared = pow(value, 2.0)
func test(val:float)->int:
	return _process_result( signi(val-value) )
var value_squared:float
func test_squared(val:float)->int:
	return _process_result( signi(val-value_squared) )
