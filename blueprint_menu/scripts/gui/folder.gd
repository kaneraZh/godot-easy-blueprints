extends UiMenu
class_name UiFolder

@export_dir var folder:String
func set_folder(v:String)->void: folder = v

func _ready():
	set_custom_minimum_size( Vector2(384, 0) )
	set_anchors_preset(Control.PRESET_VCENTER_WIDE)
	set_v_size_flags(Control.SIZE_EXPAND_FILL)
	
	var scroll:ScrollContainer = ScrollContainer.new()
	add_child(scroll)
	scroll.set_v_size_flags(Control.SIZE_EXPAND_FILL)
	#scroll.set_h_size_flags(Control.SIZE_EXPAND_FILL)
	scroll.set_follow_focus(true)
	scroll.set_horizontal_scroll_mode(ScrollContainer.SCROLL_MODE_DISABLED)
	
	var container:VBoxContainer = VBoxContainer.new()
	container.set_h_size_flags(Control.SIZE_EXPAND_FILL)
	scroll.add_child(container)
	# SETS FILES AND FOLDERS, RESPECTIVELY
	var button=func(name:String)->UiButton:
		var res:UiButton = UiButton.new()
		res.set_name(name)
		res.set_text(name)
		res.set_options(UiButton.OPTIONS.ROOT_IS_NOT_PARENT)
		res.menu_root = self
		return res
	for dir in DirAccess.get_files_at(folder):
		var btn:UiButton = button.call(dir)
		btn.set_mode(
			UiButton.MODE.CHANGE_SCENE 
			if dir.ends_with('.tscn') else 
			UiButton.MODE.EMIT_SELECTION
		)
		btn.generic_resource = load('%s/%s'%[folder, dir])
		container.add_child(btn)
	for dir in DirAccess.get_directories_at(folder):
		var btn:UiButton = button.call(dir)
		btn.set_mode(UiButton.MODE.FOLDER)
		btn.folder_directory = '%s/%s'%[folder, dir]
		container.add_child(btn)
	var btn:UiButton = button.call("Back")
	btn.set_mode(UiButton.MODE.FREE)
	container.add_child(btn)
	main_focus = container.get_child(0, true)
	super()
