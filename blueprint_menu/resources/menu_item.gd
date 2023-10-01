extends Resource
class_name MenuItem

@export var text:String : set=set_text, get=get_text
func set_text(n:String):text = n
func get_text()->String:return text

var method:StringName : set=set_method, get=get_method
func set_method(m:StringName):
#	assert(
#		SingletonMenu.has_method(method) if (method) else true,
#		'<SingletonMenu> has no method <%s()>'%m)
	method = m
func get_method()->StringName:return method

var arguments:Array : set=set_arguments, get=get_arguments
func set_arguments(a:Array):arguments = a
func get_arguments()->Array:return arguments

func get_button(owner:Node = null)->Button:
	var res:Button = Button.new()
	res.set_text(get_text())
#	res.connect('button_up', Callable(SingletonMenu, method).bindv(arguments))
	if(owner):res.set_owner(owner)
	return res
