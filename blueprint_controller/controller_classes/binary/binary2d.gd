class_name Binary2D
extends InputGroup

@export var xAxis : Binary1D: get = get_x, set = set_x
func set_x(v:Binary1D):
	xAxis = v#if (v is Binary1D) else Binary1D.new()
	xAxis.connect(&"just_pressed", Callable(self, &"_on_x_just_released"))
	xAxis.connect(&"just_released", Callable(self, &"_on_x_just_pressed"))
func get_x()->Binary1D: return xAxis
func _on_x_just_released(v:float)->void:
	emit_signal(&"just_pressed_x", v)
	emit_signal(&"just_pressed", v)
func _on_x_just_pressed(v:float)->void:
	emit_signal(&"just_released_x", v)
	emit_signal(&"just_released", v)
@export var yAxis : Binary1D: get = get_y, set = set_y
func set_y(v:Binary1D):
	yAxis = v#if (v is Binary1D) else Binary1D.new()
	yAxis.connect(&"just_pressed", Callable(self, &"_on_y_just_released"))
	yAxis.connect(&"just_released", Callable(self, &"_on_y_just_pressed"))
func get_y()->Binary1D: return yAxis
func _on_y_just_released(v:float)->void:
	emit_signal(&"just_pressed_y", v)
	emit_signal(&"just_pressed", v)
func _on_y_just_pressed(v:float)->void:
	emit_signal(&"just_released_y", v)
	emit_signal(&"just_released", v)
signal just_released_x
signal just_pressed_x
signal just_released_y
signal just_pressed_y
signal just_released
signal just_pressed
@export_flags(
"on release",
"on press"
	) var signals := 0
func set_on_release(f:bool):
	signals = (signals&(~(1<<0)))+((int(f)&1)<<0)
	set_check_every_frame(f)
func set_on_press(f:bool):
	signals = (signals&(~(1<<1)))+((int(f)&1)<<1)
	set_check_every_frame(f)
func get_on_release():	return (signals>>0)&1
func get_on_press():	return (signals>>1)&1


func press()->Vector2:
	return Vector2(xAxis.press(), yAxis.press()) * active
