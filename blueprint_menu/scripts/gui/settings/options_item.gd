@tool
extends Resource
class_name SettingsOptionsItem

@export var text:String="" : set=set_text, get=get_text
func set_text(v:String)->void: text = v
func get_text()->String: return text
@export var separator:bool=false : set=set_separator, get=is_separator
func set_separator(v:bool)->void: separator = v
func is_separator()->bool: return separator
@export var description:String="" : set=set_description
func set_description(v:String)->void: description = v
func get_description()->String: return "%s : %s"%[text, description]
