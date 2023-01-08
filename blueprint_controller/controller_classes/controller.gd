tool
class_name Controller
extends Node

export (Array, X509Certificate) var buttons setget set_buttons, get_buttons
func set_buttons(bts:Array):	buttons = bts
func get_buttons()->Array:		return buttons
func button_name(n:String):
	for b in buttons:
		if(b is ButtonBase):if(b.get_action() == n	): return b
		else:				if(b.name == n			): return b
	push_warning("Error: name <%s> not found"%n)
	print_debug( "Error: name <%s> not found"%n)
func button_id(id:int):
	assert(id<buttons.size() && id>=0, "wrong button id solicited <%s>"%id)
	return buttons[id]

export (int, FLAGS,
	"processes buttons"
	)var settings = 0b1
func set_active(a:int): settings = (a&1)<<0
func get_active()->int: return (settings>>0)&1

func _enter_tree():
	if(Engine.is_editor_hint()):_enter_tree_editor()
	else:						_enter_tree_game()
func _process(delta):
	if(Engine.is_editor_hint()):_process_editor(delta)
	else:						_process_game(delta)
func _input(event:InputEvent):
	if(Engine.is_editor_hint()):_input_editor(event)
	else:						_input_game(event)

func _enter_tree_editor():				pass
func _process_editor(_delta:float):		pass
func _input_editor(_event:InputEvent):	pass


var emits_signal = []
func _enter_tree_game():pass
func _process_game(_delta:float):
	if(get_active()):
		for b in buttons: b.press()
func _input_game(_event:InputEvent):	pass
