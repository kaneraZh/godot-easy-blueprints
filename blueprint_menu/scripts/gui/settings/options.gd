@tool
extends SettingsVaraible
class_name SettingsOptions

var option:OptionButton : set=set_option, get=get_option
func set_option(v:OptionButton)->void:
	option = v
	option.set_h_size_flags(Control.SIZE_EXPAND_FILL)
	option.set_v_size_flags(Control.SIZE_FILL)
	add_child(option, false, Node.INTERNAL_MODE_FRONT)
	option_update()
func get_option(): return option

@export var items:Array[SettingsOptionsItem]=[] : set=set_items, get=get_items
func set_items(v:Array[SettingsOptionsItem])->void:
	items = v
	option_update()
func get_items()->Array[SettingsOptionsItem]: return items
func get_item_id(item:String)->int:
	for i in items.size():
		if(items[i].get_text() == item):
			return i
	push_error("<%s> is not registered as an option"%item)
	return 0
@export var selected:int=0 : set=set_selected, get=get_selected
func set_selected(v:int)->void:
	selected = clampi(v, -1, items.size()-1)
	option_update()
func get_selected()->int: return selected
func option_update()->void:
	if(!option):return
	option.clear()
	for i in items:
		if(i.is_separator()):
			option.add_separator( i.get_text() )
		else:
			option.add_item( i.get_text() )
	option._select_int(selected)

func _ready():
	super()
	if(!option):set_option(OptionButton.new())
	
	set_selected( get_item_id(ProjectSettings.get_setting(setting)) )
	read()

enum TYPES_OPTIONS{STRING, INT, FLOAT}
const TYPES_OPTIONS_STR:String = "STRING, INT, FLOAT"
#@export var type:TYPES = TYPES.STRING
#@export var setting:String
func get_value():
	var res:String = get_option().get_item_text( get_option().get_selected_id() )
	match type:
		TYPES_OPTIONS.STRING:	return res
		TYPES_OPTIONS.INT:		return int(res)
		TYPES_OPTIONS.FLOAT:	return float(res)
func read()->void: set_selected( ProjectSettings.get_setting(setting) )
func save()->void:
	match type:
		TYPES_OPTIONS.STRING:	ProjectSettings.set_setting( setting, get_value() )
		TYPES_OPTIONS.INT:		ProjectSettings.set_setting( setting, int(get_value()) )
		TYPES_OPTIONS.FLOAT:	ProjectSettings.set_setting( setting, float(get_value()) )
func check()->bool:
	return ProjectSettings.get_setting(setting)==get_value()

func get_property_list_settings()->Array[Dictionary]:
	var properties:Array[Dictionary] = []
	properties.append({
		"name": "type",
		"class_name": "",
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": TYPES_OPTIONS_STR,
		"usage": PROPERTY_USAGE_SCRIPT_VARIABLE + PROPERTY_USAGE_DEFAULT
	})
	properties.append({
		"name": "default_value",
		"class_name": "",
		"type": [TYPE_STRING, TYPE_INT, TYPE_FLOAT][type],
		"hint": PROPERTY_HINT_NONE,
		"hint_string": "",
		"usage": PROPERTY_USAGE_SCRIPT_VARIABLE + PROPERTY_USAGE_DEFAULT
	})
	return properties
