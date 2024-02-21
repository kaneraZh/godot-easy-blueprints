@tool
extends SettingsVaraible
class_name SettingsSlider

var slider:HSlider : set=set_slider, get=get_slider
func set_slider(v:HSlider)->void:
	slider = v
	slider.set_h_size_flags(Control.SIZE_EXPAND_FILL)
	slider.set_v_size_flags(Control.SIZE_FILL)
	slider.set_stretch_ratio(5.0)
	add_child(slider, false, Node.INTERNAL_MODE_FRONT)
	components_update()
	slider_update()
func get_slider()->HSlider: return slider
var label:Label : set=set_label, get=get_label
func set_label(v:Label)->void:
	label = v
	label.set_h_size_flags(Control.SIZE_EXPAND_FILL)
	label.set_v_size_flags(Control.SIZE_FILL)
	label.set_vertical_alignment(VERTICAL_ALIGNMENT_CENTER)
	label.set_text_overrun_behavior(TextServer.OVERRUN_TRIM_CHAR)
	add_child(label, false, Node.INTERNAL_MODE_FRONT)
	components_update()
func get_label()->Label: return label
func components_update()->void:
	if!(label && slider):return
	#connect(&"focus_entered", Callable(slider, &"grab_focus"), CONNECT_DEFERRED)
	slider.connect(&"value_changed", Callable(label, &"set_text"))
	label.set_text( str(get_value()) )

@export var tick_count:int=11 : set=set_tick_count, get=get_tick_count
func set_tick_count(v:int)->void:
	tick_count = absi(v)
	set_value()
	slider_update()
func get_tick_count()->int: return tick_count
@export var ticks_on_border:bool=true : set=set_ticks_on_border, get=get_ticks_on_border
func set_ticks_on_border(v:bool)->void:
	ticks_on_border = v
	set_value()
	slider_update()
func get_ticks_on_border()->bool: return ticks_on_border
@export var max_value:float=100.0 : set=set_max_value, get=get_max_value
func set_max_value(v:float)->void:
	max_value = v
	set_value()
	slider_update()
func get_max_value()->float: return max_value
@export var min_value:float=0.0 : set=set_min_value, get=get_min_value
func set_min_value(v:float)->void:
	min_value = v
	set_value()
	slider_update()
func get_min_value()->float: return min_value
@export var step:float=1.0 : set=set_step, get=get_step
func set_step(v:float)->void:
	step = v
	set_value()
	slider_update()
func get_step()->float: return step
@export var value:float=max_value/2.0 : set=set_value#, get=get_value
func set_value(v:float=value)->void:
	value = v
	value = clampf(value, min_value, max_value)-min_value
	value = roundf( value/step )*step+min_value
	value = clampf(value, min_value, max_value)
	slider_update()
#func get_value()->float: return value
func slider_update()->void:
	if(!slider):return
	slider.set_ticks(tick_count)
	slider.set_ticks_on_borders(ticks_on_border)
	slider.set_max(max_value)
	slider.set_min(min_value)
	slider.step = step
	slider.set_value(value)

func _ready():
	super()
	if(!slider):set_slider(HSlider.new())
	if(!label): set_label(Label.new())
	type = TYPE_FLOAT
	connect(&"focus_entered", Callable(self, &"_pass_focus"))
	read()
func _pass_focus()->void:
	slider.call_deferred(&"grab_focus")

#@export var setting:String
func get_value()->float: return get_slider().get_value()
func read()->void: set_value( ProjectSettings.get_setting(setting) )
func save()->void: ProjectSettings.set_setting(setting, get_value())
func check()->bool: return ProjectSettings.get_setting(setting)==get_value()

func get_property_list_settings()->Array[Dictionary]:
	var properties:Array[Dictionary] = []
	properties.append({
		"name": "type",
		"class_name": "",
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": TYPES,
		"usage": PROPERTY_USAGE_SCRIPT_VARIABLE + PROPERTY_USAGE_NO_EDITOR
	})
	properties.append({
		"name": "default_value",
		"class_name": "",
		"type": TYPE_FLOAT,
		"hint": PROPERTY_HINT_NONE,
		"hint_string": "",
		"usage": PROPERTY_USAGE_SCRIPT_VARIABLE + PROPERTY_USAGE_DEFAULT
	})
	return properties
