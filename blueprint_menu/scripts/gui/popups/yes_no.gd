extends PanelContainer

@export var label:Label
func set_text(text:String)->void:
	label.set_text(text)

signal accept
@export var btn_accept:Button : set=set_accept, get=get_accept
func set_accept(v:Button)->void:
	btn_accept = v
	btn_accept.connect(&"pressed", Callable(self, &"emit_signal").bind(&"accept"))
	btn_accept.connect(&"pressed", Callable(self, &"queue_free"), CONNECT_DEFERRED)
func get_accept()->Button: return btn_accept

signal cancel
@export var btn_cancel:Button : set=set_cancel, get=get_cancel
func set_cancel(v:Button)->void:
	btn_cancel = v
	btn_cancel.connect(&"pressed", Callable(self, &"emit_signal").bind(&"cancel"))
	btn_cancel.connect(&"pressed", Callable(self, &"queue_free"), CONNECT_DEFERRED)
func get_cancel()->Button: return btn_cancel

func _ready():
	btn_accept.grab_focus()
