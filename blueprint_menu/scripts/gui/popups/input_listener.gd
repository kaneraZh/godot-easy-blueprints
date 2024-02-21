extends PanelContainer

@export var label:Label
signal accept
@export var btn_accept:Button : set=set_accept
func set_accept(v:Button)->void:
	btn_accept = v
	btn_accept.connect(&"pressed", Callable(self, &"_on_accept"))
	btn_accept.connect(&"pressed", Callable(self, &"queue_free"), CONNECT_DEFERRED)
@export var btn_listen:Button : set=set_listen
func set_listen(v:Button)->void:
	btn_listen = v
	btn_listen.connect(&"pressed", Callable(self, &"set_listening").bind(true))
signal cancel
@export var btn_cancel:Button : set=set_cancel
func set_cancel(v:Button)->void:
	btn_cancel = v
	btn_cancel.connect(&"pressed", Callable(self, &"emit_signal").bind(&"cancel"))
	btn_cancel.connect(&"pressed", Callable(self, &"queue_free"), CONNECT_DEFERRED)
func _on_accept()->void:
	emit_signal(&"accept", input_event)

@export_multiline var text_listening:String
@export_multiline var text_showing:String
var input_event:InputEvent : set=set_input_event
func set_input_event(v:InputEvent)->void:
	input_event = v
	set_listening(false)
	var res:String = ""
	match input_event.get_class():
		"InputEventKey":
			res+= input_event.as_text_physical_keycode()
		"InputEventMouseButton":
			match input_event.get_button_index():
				MOUSE_BUTTON_LEFT:		res+= "Left Click"
				MOUSE_BUTTON_RIGHT:		res+= "Right Click"
				MOUSE_BUTTON_MIDDLE:	res+= "Middle Click"
				MOUSE_BUTTON_WHEEL_UP:	res+= "Wheel Up"
				MOUSE_BUTTON_WHEEL_DOWN:res+= "Wheel Down"
				MOUSE_BUTTON_WHEEL_LEFT:res+= "Wheel Left"
				MOUSE_BUTTON_WHEEL_RIGHT:res+="Wheel Right"
				MOUSE_BUTTON_XBUTTON1:	res+= "Prev Click"
				MOUSE_BUTTON_XBUTTON2:	res+= "Next Click"
		"InputEventMouseMotion":
			res+= "Mouse "
			var axis:Vector2 = input_event.get_relative()
			if(abs(axis.x)>abs(axis.y)):
				res+= "x"
				res+= "+" if (axis.x>0) else "-"
			else:
				res+= "y"
				res+= "+" if (axis.y>0) else "-"
		"InputEventMIDI":
			res+= "MIDI:%s"%input_event
		"InputEventJoypadButton":
			match input_event.get_device():
				-1:pass
				_: res+= "%s's "%[input_event.get_device()+1]
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
				-1:pass
				_: res+= "%s's "%[input_event.get_device()+1]
			match input_event.get_axis():
				JOY_AXIS_LEFT_X:		res+= "L stick X"
				JOY_AXIS_LEFT_Y:		res+= "L stick Y"
				JOY_AXIS_RIGHT_X:		res+= "R stick X"
				JOY_AXIS_RIGHT_Y:		res+= "R stick Y"
				JOY_AXIS_TRIGGER_LEFT:	res+= "L Trigger "
				JOY_AXIS_TRIGGER_RIGHT:	res+= "R Trigger "
			res+= "+" if input_event.get_axis_value()>0 else "-"
	label.set_text(res)
	btn_listen.grab_focus()
func get_input_event_text()->String:
	var res:String
	match input_event.get_class():
		#"InputEventAction":
			#res = str(input_event)
		"InputEventJoypadButton":
			input_event.get_device()
			input_event.get_button_index()
			res = str(input_event)
		"InputEventJoypadMotion":
			res = str(input_event)
		"InputEventMIDI":
			res = str(input_event)
		"InputEventShortcut":
			res = str(input_event)
		"InputEventScreenDrag":
			res = str(input_event)
		"InputEventScreenTouch":
			res = str(input_event)
		"InputEventKey":
			res = str(input_event)
		"InputEventMagnifyGesture":
			res = str(input_event)
		"InputEventPanGesture":
			res = str(input_event)
		"InputEventMouseButton":
			res = str(input_event)
		"InputEventMouseMotion":
			res = str(input_event)
	return res

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
}
var device:DEVICES = DEVICES.KEYBOARD : set=set_listening_device
func set_listening_device(device_id:DEVICES)->void:
	@warning_ignore("int_as_enum_without_cast")
	device = clampi(device_id, DEVICES.JOYSTICK_1, DEVICES.MIDI_DEVICE)
var listening:bool=false : set=set_listening
func set_listening(v:bool)->void:
	listening = v
	if(listening):
		label.set_text(text_listening)
		btn_accept.set_visible(false)
		btn_listen.set_visible(false)
		release_focus()
	else:
		btn_accept.set_visible(true)
		btn_listen.set_visible(true)
func _input(event:InputEvent)->void:
	if(!listening):return
	match device:
		DEVICES.KEYBOARD:
			if( event is InputEventKey	&&
				event.is_pressed()		): set_input_event( event )
		DEVICES.MOUSE_BUTTON:
			if( event is InputEventMouseButton):set_input_event( event )
		DEVICES.MOUSE_MOTION:
			if( event is InputEventMouseMotion):set_input_event( event )
		DEVICES.MIDI_DEVICE:
			if( event is InputEventMIDI):set_input_event( event )
		DEVICES.JOYSTICK_ALL:
			if((event is InputEventJoypadButton ||
				event is InputEventJoypadMotion)&&
				event.is_pressed() ):
					event.set_device(-1 )
					set_input_event( event )
		_:
			if((event is InputEventJoypadButton ||
				event is InputEventJoypadMotion)&&
				event.get_device() == device &&
				event.is_pressed() ):
					set_input_event( event )

func _ready()->void:
	set_listening(true)

