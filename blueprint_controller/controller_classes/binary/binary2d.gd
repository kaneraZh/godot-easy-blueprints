class_name Binary2D
extends InputGroup

@export var xAxis : Binary1D: get = get_x, set = set_x
func set_x(v:Binary1D):
	xAxis = v#if (v is Binary1D) else Binary1D.new()
	xAxis.connect("just_pressed", Callable(self, "emit_signal").bind("just_pressed"))
	xAxis.connect("just_released", Callable(self, "emit_signal").bind("just_released"))
func get_x()->Binary1D: return xAxis
@export var yAxis : Binary1D: get = get_y, set = set_y
func set_y(v:Binary1D):
	yAxis = v#if (v is Binary1D) else Binary1D.new()
	yAxis.connect("just_pressed", Callable(self, "emit_signal").bind("just_pressed"))
	yAxis.connect("just_released", Callable(self, "emit_signal").bind("just_released"))
func get_y()->Binary1D: return yAxis
signal just_released
signal just_pressed

func press()->Vector2:
	return Vector2(xAxis.press(), yAxis.press()) * active
