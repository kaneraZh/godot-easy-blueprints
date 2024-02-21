@tool
extends EditorScript

class ProjectVariable:
	var name:String = "custom/"
	# Name of the setting
	# The name of the setting MUST be a branch of
	# something if the setting name isn't, it will
	# be under the "global/" branch.
	var type:Variant.Type = TYPE_INT
	# Type of the setting
	var default_value:Variant
	# Value that the setting reverts to
	
	var basic:bool = true
	# Especifies if this setting is basic or advanced
	var internal:bool = false
	# Especifies if this setting will be shown on the ProjectEditor window
	var position:int
	# Sets the position in the order of a configuration value (influences when saved to the config file).
	var restart:bool = false
	# Informs if requires restarting the editor to take effect. This is just a hint to display to the user that the editor must be restarted for changes to take effect.
	
	var hint:PropertyHint = PROPERTY_HINT_NONE
	var hint_string:String = ""
	func get_property_info()->Dictionary:
		return {
			"name": name,
			"type": type,
			"hint": hint,
			"hint_string": hint_string,
		}
	
	func make()->void:
		if(ProjectSettings.has_setting(name)):
			print("overwritting setting <%s>..."%name)
		else:
			print("creating setting <%s>..."%name)
			ProjectSettings.set_setting(name,default_value)
		ProjectSettings.set_initial_value(name,default_value)
		ProjectSettings.set_as_basic(name,basic)
		ProjectSettings.set_as_internal(name,internal)
		ProjectSettings.set_order(name,position)
		ProjectSettings.set_restart_if_changed(name,restart)
		ProjectSettings.add_property_info(get_property_info())
	static func create_setting(
		name:String			,
		type:Variant.Type	,
		default_value:Variant,
		hint:PropertyHint	= PROPERTY_HINT_NONE,
		hint_string:String	= "",
		basic:bool			= true,
		internal:bool		= false,
		restart:bool		= false,
		position:int		= 0,
	):
		assert(typeof(default_value)==type,"type of <default_value> is no the same as of <type> (%s!=%s)"%[typeof(default_value), type])
		var res:ProjectVariable = ProjectVariable.new()
		res.name		= name
		res.type		= type
		res.default_value=default_value
		res.basic		= basic
		res.internal	= internal
		res.position	= position
		res.restart		= restart
		res.hint		= hint
		res.hint_string	= hint_string
		res.make()
func _run()->void:
	# MANAGER SETTINGS
	ProjectVariable.create_setting(
		"manager/settings/settings/directory",
		TYPE_STRING,
		"user://settings.cfg")
	ProjectVariable.create_setting(
		"manager/settings/settings/include",
		TYPE_PACKED_STRING_ARRAY,
		PackedStringArray(["custom/", "manager/", "input/"]))
	ProjectVariable.create_setting(
		"manager/settings/settings/exclude",
		TYPE_PACKED_STRING_ARRAY,
		PackedStringArray(["input/ui_"]))
	ProjectVariable.create_setting(
		"manager/settings/game_data/directory",
		TYPE_STRING,
		"user://savefile.cfg")
	ProjectVariable.create_setting(
		"manager/settings/game_data/include",
		TYPE_PACKED_STRING_ARRAY,
		PackedStringArray(["game_data/"]))
	ProjectVariable.create_setting(
		"manager/settings/game_data/exclude",
		TYPE_PACKED_STRING_ARRAY,
		PackedStringArray([]))
	
	# VOLUME
	ProjectVariable.create_setting(
		"custom/audio/master/normalized_volume",
		TYPE_FLOAT,
		0.8)
	ProjectVariable.create_setting(
		"custom/audio/sfx/normalized_volume",
		TYPE_FLOAT,
		0.8)
	ProjectVariable.create_setting(
		"custom/audio/music/normalized_volume",
		TYPE_FLOAT,
		0.8)
	
	ManagerSettings.save_settings()
