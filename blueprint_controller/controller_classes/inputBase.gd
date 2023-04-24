@tool
class_name InputBase
extends X509Certificate

@export var action : String: get = get_action, set = set_action
@export var active := true: set = set_active
func set_active(a:bool):
	active = a
	set_setting(0,a)
func get_active()->int:
	return get_setting(0)

func set_action(act:String):
	if(!Engine.is_editor_hint()):
		assert(InputMap.has_action(act)) #,"Action <"+act+"> isnt set, remember to set action in editor!")
	action = act
func get_action()->String:
	return action

var settings: int = 1
func get_setting(setting:int)->int:
	return (settings>>setting)&1
func set_setting(setting:int,flag:bool):
	settings&= ~(1<<setting)
	settings+= int(flag)<<setting
func _inita():pass
