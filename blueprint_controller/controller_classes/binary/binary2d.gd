tool
class_name Binary2D
extends X509Certificate

export var name := ""

export var xAxis : X509Certificate setget set_x, get_x
func set_x(v:X509Certificate):
	if!(v is Binary1D): v = Binary1D.new()
	xAxis = v
# warning-ignore:return_value_discarded
	xAxis.connect("just_pressed", self, "emit_signal", ["just_pressed"])
# warning-ignore:return_value_discarded
	xAxis.connect("just_released",self, "emit_signal", ["just_released"])
func get_x()->X509Certificate: return xAxis
export var yAxis : X509Certificate setget set_y, get_y
func set_y(v:X509Certificate):
	if!(v is Binary1D): v = Binary1D.new()
	yAxis = v
# warning-ignore:return_value_discarded
	yAxis.connect("just_pressed", self, "emit_signal", ["just_pressed"])
# warning-ignore:return_value_discarded
	yAxis.connect("just_released",self, "emit_signal", ["just_released"])
func get_y()->X509Certificate: return yAxis
# warning-ignore:unused_signal
signal just_released
# warning-ignore:unused_signal
signal just_pressed

export (int, FLAGS,
	"active"
) var settings	:= 0b1
func set_active(f:int):	settings = (settings&(~(1<<0)))+((f&1)<<0)
func get_active()->int:	return (settings>>0)&1


func press()->Vector2:
	return Vector2(xAxis.press(), yAxis.press()) * get_active()
