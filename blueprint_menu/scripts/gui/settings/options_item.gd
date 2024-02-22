@tool
extends Resource
class_name SettingsOptionsItem

var type:Variant.Type=TYPE_INT : set=set_type, get=get_type
func get_type()->int: return type
func set_type(v:Variant.Type):
	type = v
	notify_property_list_changed()
var value : get=get_value
func get_value()->Variant:return value
@export var text:String="" : set=set_text, get=get_text
func set_text(v:String)->void: text = v
func get_text()->String: return text
@export var separator:bool=false : set=set_separator, get=is_separator
func set_separator(v:bool)->void: separator = v
func is_separator()->bool: return separator
@export var description:String="" : set=set_description
func set_description(v:String)->void: description = v
func get_description()->String: return "%s : %s"%[text, description]

func _get_property_list()->Array[Dictionary]:
	var properties:Array[Dictionary] = []
	properties.append({
		"name"			= "value",	# is the property's name, as a String;
		#"class_name"	= "",		# is an empty StringName, unless the property is TYPE_OBJECT and it inherits from a class;
		"type"			= type,	# is the property's type, as an int (see Variant.Type);
		"hint"			= PROPERTY_HINT_NONE,	# is how the property is meant to be edited (see PropertyHint);
		"hint_string"	= "",	# depends on the hint (see PropertyHint);
		"usage"			= PROPERTY_USAGE_SCRIPT_VARIABLE+PROPERTY_USAGE_DEFAULT,	# is a combination of PropertyUsageFlags.
	})
	return properties
