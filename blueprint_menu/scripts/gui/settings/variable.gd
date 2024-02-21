@tool
extends HBoxContainer
class_name SettingsVaraible

var setting:String = "custom/"
# Name of the setting
# The name of the setting MUST be a branch of
# something if the setting name isn't, it will
# be under the "global/" branch.
const TYPES:String = "TYPE_NIL,TYPE_BOOL,TYPE_INT,TYPE_FLOAT,TYPE_STRING,TYPE_VECTOR2,TYPE_VECTOR2I,TYPE_RECT2,TYPE_RECT2I,TYPE_VECTOR3,TYPE_VECTOR3I,TYPE_TRANSFORM2D,TYPE_VECTOR4,TYPE_VECTOR4I,TYPE_PLANE,TYPE_QUATERNION,TYPE_AABB,TYPE_BASIS,TYPE_TRANSFORM3D,TYPE_PROJECTION,TYPE_COLOR,TYPE_STRING_NAME,TYPE_NODE_PATH,TYPE_RID,TYPE_OBJECT,TYPE_CALLABLE,TYPE_SIGNAL,TYPE_DICTIONARY,TYPE_ARRAY,TYPE_PACKED_BYTE_ARRAY,TYPE_PACKED_INT32_ARRAY,TYPE_PACKED_INT64_ARRAY,TYPE_PACKED_FLOAT32_ARRAY,TYPE_PACKED_FLOAT64_ARRAY,TYPE_PACKED_STRING_ARRAY,TYPE_PACKED_VECTOR2_ARRAY,TYPE_PACKED_VECTOR3_ARRAY,TYPE_PACKED_COLOR_ARRAY"
var type:Variant.Type = TYPE_INT : set=set_variant_type, get=get_variant_type
func get_variant_type()->int:return type
func set_variant_type(v:Variant.Type)->void:
	type = v
	notify_property_list_changed()
# Type of the setting
var default_value:Variant
# Value that the setting reverts to
func get_property_list_settings()->Array[Dictionary]:
	var properties:Array[Dictionary] = []
	properties.append({
		"name": "type",
		"class_name": "",
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": TYPES,
		"usage": PROPERTY_USAGE_SCRIPT_VARIABLE + PROPERTY_USAGE_DEFAULT
	})
	properties.append({
		"name": "default_value",
		"class_name": "",
		"type": type,
		"hint": PROPERTY_HINT_NONE,
		"hint_string": "",
		"usage": PROPERTY_USAGE_SCRIPT_VARIABLE + PROPERTY_USAGE_DEFAULT
	})
	return properties

#var metadata_basic:bool = true
## Especifies if this setting is basic or advanced
#var metadata_internal:bool = false
## Especifies if this setting will be shown on the ProjectEditor window
#var metadata_order:int
## Sets the order of a configuration value (influences when saved to the config file).
#var metadata_restart:bool = false
## Informs if requires restarting the editor to take effect. This is just a hint to display to the user that the editor must be restarted for changes to take effect.

func _get_property_list()->Array[Dictionary]:
	var properties:Array[Dictionary] = []
	properties.append({
		"name": "Property Settings",
		"class_name": "",
		"type": TYPE_NIL,
		"hint": PROPERTY_HINT_NONE,
		"hint_string": "",
		"usage": PROPERTY_USAGE_CATEGORY
	})
	properties.append({
		"name": "setting",
		"class_name": "",
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_NONE,
		"hint_string": "",
		"usage": PROPERTY_USAGE_SCRIPT_VARIABLE + PROPERTY_USAGE_DEFAULT
	})
	properties.append_array( get_property_list_settings() )
	#properties.append({
		#"name": "Property Metadata",
		#"class_name": "",
		#"type": 0,
		#"hint": 0,
		#"hint_string": "metadata_",
		#"usage": PROPERTY_USAGE_GROUP
	#})
	#properties.append({
		#"name": "metadata_basic",
		#"class_name": "",
		#"type": TYPE_BOOL,
		#"hint": PROPERTY_HINT_NONE,
		#"hint_string": "",
		#"usage": PROPERTY_USAGE_SCRIPT_VARIABLE + PROPERTY_USAGE_DEFAULT
	#})
	#properties.append({
		#"name": "metadata_internal",
		#"class_name": "",
		#"type": TYPE_BOOL,
		#"hint": PROPERTY_HINT_NONE,
		#"hint_string": "",
		#"usage": PROPERTY_USAGE_SCRIPT_VARIABLE + PROPERTY_USAGE_DEFAULT
	#})
	#properties.append({
		#"name": "metadata_order",
		#"class_name": "",
		#"type": TYPE_INT,
		#"hint": PROPERTY_HINT_NONE,
		#"hint_string": "",
		#"usage": PROPERTY_USAGE_SCRIPT_VARIABLE + PROPERTY_USAGE_DEFAULT
	#})
	#properties.append({
		#"name": "metadata_restart",
		#"class_name": "",
		#"type": TYPE_BOOL,
		#"hint": PROPERTY_HINT_NONE,
		#"hint_string": "",
		#"usage": PROPERTY_USAGE_SCRIPT_VARIABLE + PROPERTY_USAGE_DEFAULT
	#})
	return properties

func _ready()->void:
	#ProjectSettings.set_as_basic(setting, metadata_basic) # bool
	#ProjectSettings.set_as_internal(setting, metadata_internal) # bool
	#ProjectSettings.set_initial_value(setting, default_value) # Variant
	#ProjectSettings.set_order(setting, metadata_order) # int
	#ProjectSettings.set_restart_if_changed(setting, metadata_restart) # bool
	#assert(ProjectSettings.has_setting(setting), "ProjectSettings has no setting <%s>"%setting)
	if(!ProjectSettings.has_setting(setting) ):
		ProjectSettings.set_setting(setting, default_value)
	ProjectSettings.set_initial_value(setting, default_value)
	add_to_group(get_parent().get_parent().get_name())
