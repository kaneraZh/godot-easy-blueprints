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
	
	var contents:Array = []
	contents.append_array( DirAccess.get_files_at(folder) )
	contents.append_array( DirAccess.get_directories_at(folder))
	for dir in contents:
		@warning_ignore("confusable_local_declaration")
		var btn:UiButton = UiButton.new()
		btn.set_name(dir)
		btn.set_text(dir)
		btn.set_options(UiButton.OPTIONS.ROOT_IS_NOT_PARENT)
		btn.menu_root = self
		@warning_ignore("shadowed_variable")
		var path:String = '%s/%s'%[folder, dir]
		if(dir.ends_with('.tscn')):
			btn.set_mode(UiButton.MODE.CHANGE_SCENE)
			btn.generic_resource = load(path)
		if(dir.ends_with('.tres')):
			btn.set_mode(UiButton.MODE.EMIT_SELECTION)
			btn.generic_resource = load(path)
		else:
			btn.set_mode(UiButton.MODE.FOLDER)
			btn.folder_directory = path
		container.add_child(btn)
	var btn:UiButton = UiButton.new()
	btn.set_mode(UiButton.MODE.FREE)
	btn.set_name('Back')
	btn.set_text('Back')
	btn.set_options(UiButton.OPTIONS.ROOT_IS_NOT_PARENT)
	btn.menu_root = self
	container.add_child(btn)
	
	main_focus = get_child(0, true)
	
	super()
