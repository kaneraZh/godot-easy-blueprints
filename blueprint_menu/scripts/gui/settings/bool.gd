@tool
extends SettingsVaraible
class_name SettingsBool

var checkbox:CheckBox : set=set_checkbox, get=get_checkbox
func set_checkbox(v:CheckBox)->void:
	checkbox = v
	checkbox.set_h_size_flags(Control.SIZE_EXPAND_FILL)
	checkbox.set_v_size_flags(Control.SIZE_FILL)
	add_child(checkbox, false, Node.INTERNAL_MODE_FRONT)
	read()
func get_checkbox()->CheckBox: return checkbox

func update_checkbox(pressed:bool)->void:
	if(!checkbox):return
	checkbox.set_pressed(pressed)

func _ready():
	super()
	if(!checkbox):set_checkbox(CheckBox.new())
	type = TYPE_BOOL
	read()

func get_value()->float: return get_checkbox().is_pressed()
func read()->void: update_checkbox( ProjectSettings.get_setting(setting) )
func save()->void: ProjectSettings.set_setting(setting, get_value())
func check()->bool: return ProjectSettings.get_setting(setting)==get_value()

func get_property_list_settings()->Array[Dictionary]:
	var properties:Array[Dictionary] = []
	properties.append({
		"name": "type",
		"class_name": "",
		"type": TYPE_BOOL,
		"hint": PROPERTY_HINT_NONE,
		"hint_string": "",
		"usage": PROPERTY_USAGE_SCRIPT_VARIABLE + PROPERTY_USAGE_NO_EDITOR,
	})
	properties.append({
		"name": "default_value",
		"class_name": "",
		"type": TYPE_BOOL,
		"hint": PROPERTY_HINT_NONE,
		"hint_string": "",
		"usage": PROPERTY_USAGE_SCRIPT_VARIABLE + PROPERTY_USAGE_DEFAULT,
	})
	return properties
