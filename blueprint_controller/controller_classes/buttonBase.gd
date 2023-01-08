tool
class_name ButtonBase
extends X509Certificate

export var action : String	setget set_action, get_action
export var active := true
func set_action(act:String):
	if(!Engine.is_editor_hint()):
		assert(InputMap.has_action(act), "Action <"+act+"> isnt set, remember to set action in editor!")
	action = act
func get_action()->String:
	return action

var settings: int = 1
func get_active()->int					: return (settings>>0)&1
func get_setting(setting:int)->int		: return (settings>>setting)&1
func set_setting(setting:int,flag:bool)	: settings = (settings&(~(1<<setting))) + (int(flag)<<setting)
func _inita():pass
