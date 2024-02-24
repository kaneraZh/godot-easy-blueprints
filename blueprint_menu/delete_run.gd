@tool
extends EditorScript

class test:
	signal fard
	func emit()->void: emit_signal(&"fard", 19)

func printer(a, b):
	print(a," - ", b)

func _run()->void:
	var t:test = test.new()
	t.connect(&"fard", Callable(self, &"printer").bind(99))
	t.emit()
