extends UiMenu
class_name UiSettings

var settings:Array[StringName]
@export var tab_container:TabContainer : set=set_tab_container, get=get_tab_container
func get_tab_container()->TabContainer:return tab_container
func set_tab_container(v:TabContainer)->void:
	tab_container = v
	settings = []
	for node:Node in tab_container.get_children():
		settings.append( StringName(node.get_name()) )
	#call_deferred(&"settings_read_all")

func settings_read_all()->void:
	for group:StringName in settings:
		get_tree().call_group(group, &"read")
func settings_save_all()->void:
	for group:StringName in settings:
		get_tree().call_group(group, &"save")
	@warning_ignore("static_called_on_instance")
	ManagerSettings.save_settings()
func settings_reset_all()->void:
	@warning_ignore("static_called_on_instance")
	ManagerSettings.reset_settings()
	@warning_ignore("static_called_on_instance")
	ManagerSettings.save_settings()
	for group:StringName in settings:
		get_tree().call_group(group, &"read")

func settings_read(id:int = tab_container.get_current_tab() ):
	get_tree().call_group(settings[id], &"read")
func settings_save(id:int = tab_container.get_current_tab() ):
	get_tree().call_group(settings[id], &"save")
	@warning_ignore("static_called_on_instance")
	ManagerSettings.save_settings()
func settings_reset(id:int= tab_container.get_current_tab() ):
	@warning_ignore("static_called_on_instance")
	ManagerSettings.reset_settings()
	@warning_ignore("static_called_on_instance")
	ManagerSettings.save_settings()
	get_tree().call_group(settings[id], &"read")

func settings_check_all()->bool:
	for group:StringName in settings:
		for node:Control in get_tree().get_nodes_in_group(group):
			if( !node.call(&'check') ): return false
	return true
func settings_check(id:int = tab_container.get_current_tab() )->bool:
	for node:Button in get_tree().get_nodes_in_group(settings[id]):
		if( !node.call(&'check') ): return false
	return true

func _ready()->void:
	main_focus = tab_container.get_tab_bar()
	super()
