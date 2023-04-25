class_name Analog2D
extends InputGroup

@export var xAxis:Analog1D : get=get_x, set=set_x
func set_x(x:Analog1D):
	xAxis = x
	xAxis.connect("just_above", Callable(self, "just_above_x"))
	xAxis.connect("just_below", Callable(self, "just_below_x"))
	xAxis.append_thresholds(thresholds)
func get_x()->Analog1D: return xAxis
@export var yAxis:Analog1D : get=get_y, set=set_y
func set_y(y:Analog1D):
	yAxis = y
	yAxis.connect("just_above", Callable(self, "just_above_y"))
	yAxis.connect("just_below", Callable(self, "just_below_y"))
	yAxis.append_thresholds(thresholds)
func get_y()->Analog1D: return yAxis
signal just_above
signal just_below

@export var thresholds:Array[ThresholdAbs] = []: set = set_thresholds
func set_thresholds(th:Array):
	thresholds = th

func press()->Vector2:
	return Vector2(xAxis.press(), yAxis.press()) * active
