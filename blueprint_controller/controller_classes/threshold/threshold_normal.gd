extends Threshold
class_name ThresholdNormal
@export_range(-1.0, 1.0) var value := 0.0
func test(val:float)->int:
	return _process_result(
		clampi( signi(abs(val)-abs(value)), -get_on_below(), get_on_above())
	)
