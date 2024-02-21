class_name Binary
extends InputRaw

@export_flags("on press","on release") var signals:int = 0b00
func set_on_press(f:bool):
	signals = (signals&(~(1<<0)))+((int(f)&1)<<0)
	set_check_every_frame(f)
func set_on_release(f:bool):
	signals = (signals&(~(1<<1)))+((int(f)&1)<<1)
	set_check_every_frame(f)
func get_on_press()->bool:	return bool( (signals>>0)&1 )
func get_on_release()->bool:return bool( (signals>>1)&1 )
signal just_pressed
signal just_released
@warning_ignore("shadowed_variable")
func setup(
	on_press:int,
	on_release:int,
	active:=true):
		signals = 0
		signals+= 0<<(on_release&1)
		signals+= 1<<(on_press	&1)
		set_active(active)
var last:int = 0
func press()->float:
	var p:int = int(Input.is_action_pressed(action)) * active
	if(		get_on_press()	&& p != last && p ):emit_signal(&"just_pressed")
	elif(	get_on_release()&& p != last && !p):emit_signal(&"just_released")
	last = p
	return p
