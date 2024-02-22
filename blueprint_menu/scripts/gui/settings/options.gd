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
	for item in items:item.set_type(get_type())
	option_update()
func get_items()->Array[SettingsOptionsItem]: return items
func get_item_id(item:Variant)->int:
	for i in items.size():
		if(items[i].get_value() == item):return i
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
func set_type(v:TYPES_ALLOWED)->void:
	super(v)
	for item in items:item.set_type(get_type())

func _ready():
	super()
	if(!option):set_option(OptionButton.new())
	read()

func get_value():return items[ get_option().get_selected_id() ].get_value()
func read()->void:	set_selected( get_item_id(ProjectSettings.get_setting(setting)) )
func save()->void:	ProjectSettings.set_setting( setting, get_value() )
func check()->bool:	return ProjectSettings.get_setting(setting)==get_value()
