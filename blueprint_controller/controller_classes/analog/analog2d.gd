tool
class_name Analog2D
extends X509Certificate

export var name := ""

export var xAxis : X509Certificate setget set_x, get_x
func set_x(x:X509Certificate):
	if!(x is Analog1D): x = Analog1D.new()
	xAxis = x
# warning-ignore:return_value_discarded
	xAxis.connect("just_above", self, "just_above_x")
# warning-ignore:return_value_discarded
	xAxis.connect("just_below", self, "just_below_x")
func get_x()->X509Certificate: return xAxis
export var yAxis : X509Certificate setget set_y, get_y
func set_y(y:X509Certificate):
	if!(y is Analog1D): y = Analog1D.new()
	yAxis = y
# warning-ignore:return_value_discarded
	yAxis.connect("just_above", self, "just_above_y")
# warning-ignore:return_value_discarded
	yAxis.connect("just_below", self, "just_below_y")
func get_y()->X509Certificate: return yAxis
# warning-ignore:unused_signal
signal just_above
# warning-ignore:unused_signal
signal just_below

export (Array, Resource) var thresholds:= [] setget set_thresholds
func set_thresholds(th:Array):
	for i in th.size():
		if!(th[i] is threshold_abs): th[i] = threshold_abs.new()
	thresholds = th

export (int, FLAGS,
	"active"
) var settings	:= 0
func set_active(f:int):	settings = (settings&(~(1<<0)))+((f&1)<<0)
func get_active()->int:	return (settings>>0)&1

func press()->Vector2:
	return Vector2(xAxis.press(), yAxis.press()) * get_active()
