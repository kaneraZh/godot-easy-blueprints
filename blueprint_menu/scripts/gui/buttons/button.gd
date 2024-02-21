@tool
extends Button
class_name UiButton

# FREE				: frees the root_node
# MENU				: adds a menu through root_node
# CHANGE_SCENE		: changes scene to especified PackedScene
# EMIT_SELECTION	: emits especific resource
# FOLDER			: adds a UiFolder menu on especified folder
# METHOD			: Calls a method on the especified class
enum MODE{FREE, MENU, CHANGE_SCENE, EMIT_SELECTION, FOLDER, METHOD}
@export var mode:MODE=MODE.FREE : set=set_mode, get=get_mode
func get_mode()->MODE:return mode
func set_mode(v:MODE)->void:
	mode = v
	notify_property_list_changed()

enum OPTIONS {
	ROOT_IS_NOT_PARENT	= 0b00,
	ROOT_IS_PARENT		= 0b01,
	USE_POPUP			= 0b10,
}
@export_flags(
	"root is parent",
	"use popup",
	) var options:int = 1 : set=set_options, get=get_options
func get_options()->int:return options
func set_options(v:int)->void:
	options = v
	notify_property_list_changed()
func is_root_parent()->int: return options&1
func is_popup()->int: return (options>>1)&1

var generic_resource:Resource	= null
var folder_directory:String		= ''
enum METHODS_CLASSES { MENU_ROOT, SCENE_TREE, MANAGER_SETTINGS }
const METHODS_CLASSES_STR:String= "MENU_ROOT, SCENE_TREE, MANAGER_SETTINGS"
var method_class:METHODS_CLASSES= METHODS_CLASSES.SCENE_TREE
var method_method:StringName	= StringName()
var menu_root:UiMenu : set=set_menu_root, get=get_menu_root
func get_menu_root()->UiMenu: return get_parent() if is_root_parent() else menu_root
func set_menu_root(v:UiMenu)->void: menu_root = v

# CONFIRMATION		: Confirms that you REALLY wanted to press that button
# CHECK_METHOD		: Checks a method on local_root, expects a bool, if:
#						false: it shows the popup for confirmation of the
#						action, if accepted, the action will be perfomed.
#						true: it performs the action
enum POPUP_MODE {
	CONFIRMATION,
	CHECK_METHOD,
}
const POPUP_MODE_STR = "CONFIRMATION,CHECK_METHOD"
var popup_mode:POPUP_MODE		= POPUP_MODE.CONFIRMATION : set=set_mode_popup, get=get_mode_popup
func get_mode_popup()->POPUP_MODE: return popup_mode
func set_mode_popup(v:POPUP_MODE)->void:
	popup_mode = v
	notify_property_list_changed()
var popup_check_method:StringName=&""
var popup_scene:PackedScene		= null
var popup_text:String			= ''
func get_popup()->Control:
	assert(popup_scene is PackedScene)
	var pop:Control = popup_scene.instantiate()
	pop.set_text(popup_text)
	pop.connect(&"accept", Callable(self, &"_on_success"), CONNECT_DEFERRED)
	#pop.connect(&"cancel", Callable(self, &"_on_failure"), CONNECT_DEFERRED)
	pop.connect(&"tree_exited", Callable(self, &"grab_focus"), CONNECT_DEFERRED)
	return pop
func get_node_()->Node:
	match mode:
		MODE.MENU:
			assert(generic_resource is PackedScene)
			return generic_resource.instantiate()
		MODE.FOLDER:
			assert(folder_directory is String)
			var menu:UiFolder = UiFolder.new()
			menu.set_anchors_preset(Control.PRESET_FULL_RECT)
			menu.set_folder(folder_directory)
			return menu
	return null

func _get_property_list()->Array[Dictionary]:
	var properties:Array[Dictionary] = []
	match is_root_parent():
		0:
			properties.append({
				"name": "menu_root",
				#"class_name": "Node",
				"type": TYPE_OBJECT,
				"hint": PROPERTY_HINT_NODE_TYPE,
				"hint_string": "UiMenu",
				"usage": 4102
			})
	match mode:
		MODE.MENU:
			properties.append({
				"name": "Menu",
				"class_name": "",
				"type": 0,
				"hint": 0,
				"hint_string": "generic_",
				"usage": 64
			})
			properties.append({
				"name": "generic_resource",
				"class_name": "",
				"type": TYPE_OBJECT,
				"hint": PROPERTY_HINT_RESOURCE_TYPE,
				"hint_string": "PackedScene",
				"usage": 4102
			})
		MODE.CHANGE_SCENE:
			properties.append({
				"name": "Change Scene",
				"class_name": "",
				"type": 0,
				"hint": 0,
				"hint_string": "generic_",
				"usage": 64
			})
			properties.append({
				"name": "generic_resource",
				"class_name": "PackedScene",
				"type": TYPE_OBJECT,
				"hint": PROPERTY_HINT_RESOURCE_TYPE,
				"hint_string": "PackedScene",
				"usage": 4102
			})
		MODE.EMIT_SELECTION:
			properties.append({
				"name": "Emit Selection",
				"class_name": "",
				"type": 0,
				"hint": 0,
				"hint_string": "generic_",
				"usage": 64
			})
			properties.append({
				"name": "generic_resource",
				"class_name": "Resource",
				"type": TYPE_OBJECT,
				"hint": PROPERTY_HINT_RESOURCE_TYPE,
				"hint_string": "Resource",
				"usage": 4102
			})
		MODE.FOLDER:
			properties.append({
				"name": "Folder",
				"class_name": "",
				"type": 0,
				"hint": 0,
				"hint_string": "folder_",
				"usage": 64
			})
			properties.append({
				"name": "folder_directory",
				#"class_name": "Resource",
				"type": TYPE_STRING,
				"hint": PROPERTY_HINT_DIR,
				"hint_string": "",
				"usage": 4102
			})
		MODE.METHOD:
			properties.append({
				"name": "Method",
				"class_name": "",
				"type": 0,
				"hint": 0,
				"hint_string": "method_",
				"usage": 64
			})
			properties.append({
				"name": "method_class",
				#"class_name": "",
				"type": TYPE_INT,
				"hint": PROPERTY_HINT_ENUM,
				"hint_string": METHODS_CLASSES_STR,
				"usage": 4102
			})
			properties.append({
				"name": "method_method",
				#"class_name": "",
				"type": TYPE_STRING_NAME,
				"hint": PROPERTY_HINT_NONE,
				#"hint_string": "PackedScene",
				"usage": 4102
			})
	match is_popup():
		1:
			properties.append({
				"name": "Popup",
				"class_name": "",
				"type": 0,
				"hint": 0,
				"hint_string": "popup_",
				"usage": 64
			})
			properties.append({
				"name": "popup_mode",
				#"class_name": "",
				"type": TYPE_INT,
				"hint": PROPERTY_HINT_ENUM,
				"hint_string": POPUP_MODE_STR,
				"usage": 4102
			})
			properties.append({
				"name": "popup_scene",
				#"class_name": "",
				"type": TYPE_OBJECT,
				"hint": PROPERTY_HINT_RESOURCE_TYPE,
				"hint_string": "PackedScene",
				"usage": 4102
			})
			if(popup_mode == POPUP_MODE.CHECK_METHOD):
				properties.append({
					"name": "popup_check_method",
					#"class_name": "",
					"type": TYPE_STRING_NAME,
					"hint": PROPERTY_HINT_NONE,
					"hint_string": "",
					"usage": 4102
				})
			properties.append({
				"name": "popup_text",
				#"class_name": "",
				"type": TYPE_STRING,
				"hint": PROPERTY_HINT_MULTILINE_TEXT,
				"hint_string": "",
				"usage": 4102
			})
	return properties

func _ready():
	connect(&"pressed", Callable(self, &'_on_press'))

signal selected
func _on_press()->void:
	match is_popup():
		1:
			match popup_mode:
				POPUP_MODE.CONFIRMATION:
					menu_root.add_popup( get_popup() )
				POPUP_MODE.CHECK_METHOD:
					if(!menu_root.call(popup_check_method) ):
						menu_root.add_popup( get_popup() )
					else :
						_on_success()
		0: _on_success()
func _on_success()->void:
	match mode:
		MODE.FREE:
			menu_root.queue_free()
		MODE.MENU:
			var menu:Control = get_node_()
			menu.connect(&'tree_exiting', Callable(self, &'grab_focus'), CONNECT_DEFERRED)
			menu_root.add_menu(menu)
		MODE.CHANGE_SCENE:
			assert(generic_resource is PackedScene)
			get_tree().call_deferred(&"change_scene_to_packed", generic_resource)
			print_debug("changed to scene <%s>"%generic_resource)
		MODE.EMIT_SELECTION:
			assert(generic_resource is Resource)
			emit_signal(&'selected', generic_resource)
			print_debug("emmited resource <%s>"%generic_resource)
		MODE.FOLDER:
			var menu:UiFolder = get_node_()
			menu.connect(&'tree_exiting', Callable(self, &'grab_focus'), CONNECT_DEFERRED)
			menu_root.add_menu(menu)
		MODE.METHOD:
			match method_class:
				METHODS_CLASSES.MENU_ROOT:
					menu_root.call(method_method)
				METHODS_CLASSES.SCENE_TREE:
					get_tree().call(method_method)
				METHODS_CLASSES.MANAGER_SETTINGS:
					ManagerSettings.call(method_method)

#func _on_failure()->void:
	#pass
