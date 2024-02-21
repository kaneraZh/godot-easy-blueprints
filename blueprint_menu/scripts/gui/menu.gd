extends VBoxContainer
class_name UiMenu

signal selected
@export var free_on_select:bool = false
@export var path:String="" : set=set_path#, get=get_path
func set_path(v:String): path = v
func get_path_step(id:int = 0): return path.rsplit('/')[id]

@export var main_focus:Control = null
func _ready():
	set_anchors_preset(Control.PRESET_VCENTER_WIDE)
	set_focus_control(FocusInheritanceController.new())
	
	var sig:StringName = &"selected"
	for c in get_children():
		if( c.has_signal(sig) ):
			c.connect(sig, Callable(self, &"emit_signal").bind(sig))
	
	if(free_on_select):
		connect(sig, Callable(self, &"queue_free"), CONNECT_DEFERRED)
	
	if(path):
		assert(find_child( get_path_step() )!=null, 'No button named <%s>'%get_path_step())
		find_child( get_path_step() ).call_deferred(&'_on_press')
	else:
		main_focus.grab_focus()

var focus_control:FocusInheritanceController : set=set_focus_control
func set_focus_control(v:FocusInheritanceController)->void:
	focus_control = v
	focus_control.set_root(self)
func add_menu(menu:UiMenu)->void:
	set_visible(false)
	if(!path.is_empty()):
		menu.set_path( path.lstrip('%s/'%get_path_step()) )
		path = ""
	menu.connect(&"tree_exiting", Callable(self, &"set_visible").bind(true), CONNECT_DEFERRED)
	add_sibling(menu)
	#menu.call_deferred(&"grab_focus")
func add_popup(menu:Control)->void:
	add_sibling(menu)
	focus_control.set_mode_branches(Control.FOCUS_NONE)
	menu.connect(&"tree_exiting", Callable(focus_control, &"set_mode_branches").bind(Control.FOCUS_ALL))
