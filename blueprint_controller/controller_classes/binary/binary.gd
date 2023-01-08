tool
class_name Binary
extends ButtonBase

export (int, FLAGS,
	"OnPress",
	"OnRelease"
) var signals = 0b00
func set_onPress(f:int):	signals = (signals&(~(1<<0)))+((f&1)<<0)
func set_onRelease(f:int):	signals = (signals&(~(1<<1)))+((f&1)<<1)
func get_onPress()->int:	return (signals>>0)&1
func get_onRelease()->int:	return (signals>>1)&1
signal just_pressed
signal just_released
func setup(
	onPress:int,
	onRelease:int,
	active:=true):
		self.signals	= 0
		self.signals	+=0<<(onRelease	&1)
		self.signals	+=1<<(onPress	&1)
		self.active		= active
var last := 0
func press()->float:
	var p = float(Input.is_action_pressed(action)) * get_active()
	if(		get_onPress()	&& p != last && p): emit_signal("just_pressed")
	elif(	get_onRelease()	&& p != last && !p):emit_signal("just_released")
	last = p
	return p
