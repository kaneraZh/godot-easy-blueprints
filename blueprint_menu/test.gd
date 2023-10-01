@tool
extends VBoxContainer
class_name VBoxMenuSimple

@export var items:Array[MenuItem]=[] : set=set_items, get=get_items
func set_items(i:Array[MenuItem]):
	if(!is_inside_tree()):
		connect("ready", Callable(self, "set_items").bind(i))
		return
	for c in get_children():c.queue_free()
	items = i
	for b in items:
		if!(b is MenuItem):continue
		add_child(b.get_button(get_owner()), false, Node.INTERNAL_MODE_FRONT)
func get_items()->Array[MenuItem]:
	return items


func _ready():
	pass

func _process(delta:float):
	pass
