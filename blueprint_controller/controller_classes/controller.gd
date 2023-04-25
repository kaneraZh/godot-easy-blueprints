@tool
class_name Controller
extends Node

var inputs:Array
func _update_inputs():
	inputs = buttons
	inputs.append_array(groups)
@export var buttons:Array[InputRaw]		:set=set_buttons
func set_buttons(b:Array[InputRaw])->void:
	buttons = b
	_update_inputs()
func add_button(b:InputRaw):
	buttons.append(b)
	_update_inputs()
func append_buttons(b:Array[InputRaw]):
	buttons.append_array(b)
	_update_inputs()
@export var groups:Array[InputGroup]	:set=set_groups
func set_groups(g:Array[InputGroup])->void:
	groups = g
	_update_inputs()
func add_group(g:InputGroup):
	groups.append(g)
	_update_inputs()
func append_groups(g:Array[InputGroup]):
	groups.append_array(g)
	_update_inputs()

func get_button_id(id:int)->InputRaw:
	assert(id<buttons.size() && id>=0,"wrong button id solicited <%s>"%id)
	return buttons[id]
func get_group_id(id:int)->InputGroup:
	assert(id<groups.size() && id>=0,"wrong group id solicited <%s>"%id)
	return groups[id]

#func get_button_name(nm:StringName)->InputRaw:
#	assert(id<buttons.size() && id>=0,"wrong button id solicited <%s>"%id)
#	return buttons[id]
#func get_group_id(id:int)->InputGroup:
#	assert(id<groups.size() && id>=0,"wrong group id solicited <%s>"%id)
#	return groups[id]

@export_flags("process"
	)var settings = 0b1
func set_active(a:int):
	settings&= ~(settings&(1<<0))
	settings+= (a&1)<<0
func get_active()->int:
	return (settings>>0)&1

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
		for i in inputs: i.press()
func _input_game(_event:InputEvent):	pass
