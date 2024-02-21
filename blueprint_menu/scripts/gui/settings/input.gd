@tool
extends MenuButton
class_name SettingsInput

@export var action:StringName : set=set_action, get=get_action
func get_action()->StringName: return action
func set_action(v:StringName)->void: action = v
#func is_action()->bool: return InputMap.has_action(action)
enum DEVICES{
	ALL			=-1,
	JOYSTICK_1	= 0,
	JOYSTICK_2	= 1,
	JOYSTICK_3	= 2,
	JOYSTICK_4	= 3,
	JOYSTICK_5	= 4,
	JOYSTICK_6	= 5,
	JOYSTICK_7	= 6,
	JOYSTICK_8	= 7,
	JOYSTICK_ALL= 8,
	KEYBOARD	= 9,
	MOUSE_BUTTON=10,
	MOUSE_MOTION=11,
	MIDI_DEVICE	=12,
	NONE		=13,
}
#@export var device:DEVICES = DEVICES.ALL
@export_flags(
	"Joystick 1",
	"Joystick 2",
	"Joystick 3",
	"Joystick 4",
	"Joystick 5",
	"Joystick 6",
	"Joystick 7",
	"Joystick 8",
	"Any Joystick",
	"Keyboard",
	"Mouse Button",
	"Mouse Motion",
	"MIDI Device",
) var allowed_devices:int = 0b0111100000000
func use_joystick_1()->int:		return (allowed_devices>>DEVICES.JOYSTICK_1	)&1
func use_joystick_2()->int:		return (allowed_devices>>DEVICES.JOYSTICK_2	)&1
func use_joystick_3()->int:		return (allowed_devices>>DEVICES.JOYSTICK_3	)&1
func use_joystick_4()->int:		return (allowed_devices>>DEVICES.JOYSTICK_4	)&1
func use_joystick_5()->int:		return (allowed_devices>>DEVICES.JOYSTICK_5	)&1
func use_joystick_6()->int:		return (allowed_devices>>DEVICES.JOYSTICK_6	)&1
func use_joystick_7()->int:		return (allowed_devices>>DEVICES.JOYSTICK_7	)&1
func use_joystick_8()->int:		return (allowed_devices>>DEVICES.JOYSTICK_8	)&1
func use_joystick_all()->int:	return (allowed_devices>>DEVICES.JOYSTICK_ALL	)&1
func use_keyboard()->int:		return (allowed_devices>>DEVICES.KEYBOARD		)&1
func use_mouse_button()->int:	return (allowed_devices>>DEVICES.MOUSE_BUTTON	)&1
func use_mouse_motion()->int:	return (allowed_devices>>DEVICES.MOUSE_MOTION	)&1
func use_MIDI_device()->int:	return (allowed_devices>>DEVICES.MIDI_DEVICE	)&1
func use_joystick_any()->int:	return allowed_devices&0x111111111
func filter_event(event:InputEvent)->bool:
	match event.get_class():
		"InputEventKey":		return bool(use_keyboard())
		"InputEventMouseButton":return bool(use_mouse_button())
		"InputEventMouseMotion":return bool(use_mouse_motion())
		"InputEventMIDI":		return bool(use_MIDI_device())
		"InputEventJoypadButton":
			if( !use_joystick_any() ): return false
			match event.get_device():
				-1:return bool( use_joystick_all() )
				0: return bool( use_joystick_1() )
				1: return bool( use_joystick_2() )
				2: return bool( use_joystick_3() )
				3: return bool( use_joystick_4() )
				4: return bool( use_joystick_5() )
				5: return bool( use_joystick_6() )
				6: return bool( use_joystick_7() )
				7: return bool( use_joystick_8() )
		"InputEventJoypadMotion":
			if( !use_joystick_any() ): return false
			match event.get_device():
				-1:return bool( use_joystick_all() )
				0: return bool( use_joystick_1() )
				1: return bool( use_joystick_2() )
				2: return bool( use_joystick_3() )
				3: return bool( use_joystick_4() )
				4: return bool( use_joystick_5() )
				5: return bool( use_joystick_6() )
				6: return bool( use_joystick_7() )
				7: return bool( use_joystick_8() )
	return false
func get_devices_array(devices:int=allowed_devices)->PackedInt32Array:
	var res:PackedInt32Array = []
	var id:int = 0
	while(devices>0):
		if(devices&1):res.append(id)
		devices = devices>>1
		id+= 1
	res.append(DEVICES.NONE)
	return res

var input_event_id:int = 0
var input_event_old:InputEvent=null
var input_event:InputEvent=null : set=set_input_event
func set_input_event(v:InputEvent)->void:
	input_event = v
	if(input_event==null):
		set_text(". . .")
		return
	match input_event.get_class():
		"InputEventKey":
			input_event.set_pressed(false)
			input_event.set_key_label(0)
			input_event.set_keycode(0)
			input_event.set_device(-1)
		"InputEventMouseButton":
			input_event.set_pressed(false)
			input_event.set_button_mask(0)
			input_event.set_position(Vector2())
			input_event.set_global_position(Vector2())
			input_event.set_device(-1)
	
	var res:String = "..."
	match input_event.get_class():
		"InputEventKey":
			res = input_event.as_text_physical_keycode()
		"InputEventMouseButton":
			match input_event.get_button_index():
				MOUSE_BUTTON_LEFT:		res = "Left Click"
				MOUSE_BUTTON_RIGHT:		res = "Right Click"
				MOUSE_BUTTON_MIDDLE:	res = "Middle Click"
				MOUSE_BUTTON_WHEEL_UP:	res = "Wheel Up"
				MOUSE_BUTTON_WHEEL_DOWN:res = "Wheel Down"
				MOUSE_BUTTON_WHEEL_LEFT:res = "Wheel Left"
				MOUSE_BUTTON_WHEEL_RIGHT:res= "Wheel Right"
				MOUSE_BUTTON_XBUTTON1:	res = "Prev Click"
				MOUSE_BUTTON_XBUTTON2:	res = "Next Click"
		"InputEventMouseMotion":
			res = "Mouse "
			var axis:Vector2 = input_event.get_relative()
			if(abs(axis.x)>abs(axis.y)):
				res+= "x"
				res+= "+" if (axis.x>0) else "-"
			else:
				res+= "y"
				res+= "+" if (axis.y>0) else "-"
		"InputEventMIDI":
			res = "MIDI:%s"%input_event
		"InputEventJoypadButton":
			match input_event.get_device():
				-1:res = ""
				_: res = "%s's "%[input_event.get_device()+1]
			match input_event.get_button_index():
				JOY_BUTTON_A:				res+= "A"
				JOY_BUTTON_B:				res+= "B"
				JOY_BUTTON_X:				res+= "X"
				JOY_BUTTON_Y:				res+= "Y"
				JOY_BUTTON_BACK:			res+= "Back"
				JOY_BUTTON_GUIDE:			res+= "Guide"
				JOY_BUTTON_START:			res+= "Start"
				JOY_BUTTON_LEFT_STICK:		res+= "L Stick"
				JOY_BUTTON_RIGHT_STICK:		res+= "R Stick"
				JOY_BUTTON_LEFT_SHOULDER:	res+= "L Shoulder"
				JOY_BUTTON_RIGHT_SHOULDER:	res+= "R Shoulder"
				JOY_BUTTON_DPAD_UP:			res+= "Dpad Up"
				JOY_BUTTON_DPAD_DOWN:		res+= "Dpad Down"
				JOY_BUTTON_DPAD_LEFT:		res+= "Dpad Left"
				JOY_BUTTON_DPAD_RIGHT:		res+= "Dpad Right"
				JOY_BUTTON_MISC1:			res+= "Misc"
		"InputEventJoypadMotion":
			match input_event.get_device():
				-1:res = ""
				_: res+= "%s's "%[input_event.get_device()+1]
			match input_event.get_axis():
				JOY_AXIS_LEFT_X:		res+= "L stick x"
				JOY_AXIS_LEFT_Y:		res+= "L stick y"
				JOY_AXIS_RIGHT_X:		res+= "R stick x"
				JOY_AXIS_RIGHT_Y:		res+= "R stick y"
				JOY_AXIS_TRIGGER_LEFT:	res+= "L Trigger "
				JOY_AXIS_TRIGGER_RIGHT:	res+= "R Trigger "
			res+= "+" if input_event.get_axis_value()>0 else "-"
	set_text(res)
@export var menu_root:UiMenu
@export var popup_scene:PackedScene = null
var devices_array:PackedInt32Array
func _on_selection(item_id:int)->void:
	#print("Recived item <%02s> device <%02s>"%[item_id, device_id])
	#print_debug("Recived item <%s> device <%s>"%[item_id, device_id])
	var device_id:int = devices_array[item_id]
	match device_id:
		DEVICES.NONE:
			set_input_event(null)
		_:
			var popup:Control = popup_scene.instantiate()
			popup.connect(&"tree_exiting", Callable(self, &"grab_focus"), CONNECT_DEFERRED)
			popup.connect(&"accept", Callable(self, &"set_input_event"))
			#print_debug("Called listener with <%s>"%[device_id])
			popup.set_listening_device(device_id)
			menu_root.add_popup(popup)

static var action_instances:Dictionary = {}
func _ready()->void:
	add_to_group(get_parent().get_parent().get_name())
	
	var popup:PopupMenu = get_popup()
	popup.clear(true)
	if(use_joystick_1()):	popup.add_item("Joystick 1")
	if(use_joystick_2()):	popup.add_item("Joystick 2")
	if(use_joystick_3()):	popup.add_item("Joystick 3")
	if(use_joystick_4()):	popup.add_item("Joystick 4")
	if(use_joystick_5()):	popup.add_item("Joystick 5")
	if(use_joystick_6()):	popup.add_item("Joystick 6")
	if(use_joystick_7()):	popup.add_item("Joystick 7")
	if(use_joystick_8()):	popup.add_item("Joystick 8")
	if(use_joystick_all()):	popup.add_item("Joystick")
	if(use_keyboard()):		popup.add_item("Keyboard")
	if(use_mouse_button()):	popup.add_item("Mouse")
	if(use_mouse_motion()):	popup.add_item("Mouse Motion")
	if(use_MIDI_device()):	popup.add_item("MIDI Device")
	devices_array = get_devices_array()
	popup.add_item("Clear")
	popup.connect(&"index_pressed", Callable(self, &"_on_selection"))
	
	assert(InputMap.has_action(action), "requested action is not a registered action")
	input_event_id = action_instances[action]+1 if action_instances.has(action) else 0
	action_instances[action] = input_event_id
	read()

func _exit_tree()->void:
	action_instances[action]-= 1

func read()->void:
	var events:Array[InputEvent] = InputMap.action_get_events(action)
	var count:int = 0
	var event:InputEvent = null
	for ev in events:
		if(filter_event(ev) ):
			if(count==input_event_id):
				event = ev
				break
			count+= 1
	set_input_event(event)
	input_event_old = event
	#print("loaded action <%s>\twith <%s>"%[action, input_event])
func save()->void:
	if(input_event_old != input_event):
		if(input_event_old != null):
			InputMap.action_erase_event(action, input_event_old)
		InputMap.action_add_event(action, input_event)
	call_deferred(&"read")
func check()->bool:
	if(input_event == null): return input_event_old == null
	return InputMap.action_has_event(action, input_event)
