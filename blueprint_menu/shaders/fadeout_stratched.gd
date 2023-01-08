class_name ButtonFade
extends Button

export var press:Color	= Color(16 ,50 ,142)
export var focus:Color	= Color(73 ,134,178)
export var unfocus:Color= Color(154,193,193)
func _init():
# warning-ignore:return_value_discarded
# warning-ignore:return_value_discarded
# warning-ignore:return_value_discarded
# warning-ignore:return_value_discarded
# warning-ignore:return_value_discarded
# warning-ignore:return_value_discarded
# warning-ignore:return_value_discarded
	connect("button_down",	self, "on_press")
	connect("button_up",	self, "on_button_up")
	connect("focus_entered",self, "on_focus_grab")
	connect("focus_exited",	self, "on_focus_lost")
	connect("mouse_entered",self, "on_focus_grab")
	connect("mouse_exited",	self, "on_focus_lost")
	connect("tree_entered",	self, "on_focus_lost", [], CONNECT_ONESHOT)
	set_material(get_material().duplicate())
	set_text_align(Button.ALIGN_LEFT)
func on_press():
	get_material().set_shader_param("color", press)
func on_button_up():
	if(get_focus_owner() == self):	on_focus_grab()
	else:							on_focus_lost()
func on_focus_grab():
	get_material().set_shader_param("color", focus)
func on_focus_lost():
	get_material().set_shader_param("color", unfocus)
