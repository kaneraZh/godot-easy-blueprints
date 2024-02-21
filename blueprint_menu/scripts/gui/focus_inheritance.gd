extends Resource
class_name FocusInheritanceController

@export var mode:Control.FocusMode = Control.FOCUS_ALL
var focus_branches:Array[Control]
var root:Node=null : set=set_root
func set_root(node:Node)->void:
	root = node
	focus_branches = _find_focus_branches(root)
func _find_focus_branches(parent:Node)->Array[Control]:
	var res:Array[Control] = []
	for n:Node in parent.get_children(true):
		if(n is Control):
			if(n.get_focus_mode()==mode):res.append(n)
		if(n.get_child_count(true)>0):
			res.append_array( _find_focus_branches(n) )
	return res

func set_mode_branches(focus_mode:Control.FocusMode)->void:
	for n:Control in focus_branches:
		n.set_focus_mode(focus_mode)
